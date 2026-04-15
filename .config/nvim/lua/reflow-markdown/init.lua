-- reflow-markdown.nvim
-- Rewrap LSP markdown hovers so paragraphs reflow cleanly, matching
-- CommonMark / VS Code behavior. Preserves fenced code blocks, headings,
-- tables, blockquotes, lists (with lazy continuation), horizontal rules,
-- and explicit hard line breaks.
--
-- Neovim's LSP hover pipeline passes `contents` straight through to the
-- float buffer without applying CommonMark's rule that a single `\n`
-- within a paragraph is a soft break (rendered as a space). LSP servers
-- like rust-analyzer hard-wrap doc text at ~80 cols, so hovers look
-- ragged. Decorator plugins (render-markdown.nvim, markview.nvim) can't
-- fix this because they only paint over existing lines. The correct
-- choke-point is the line list *before* it's written to the float buffer.

local M = {}

---@class reflow.Options
---@field pad_fences boolean? Insert blank lines around fenced code blocks so renderers can cleanly conceal fence markers. Default: true.
---@field pad_headings boolean? Insert a blank line before ATX headings (`#`, `##`, ...) when the previous line is prose. CommonMark allows headings without leading blanks, but they read better with paragraph separation — matching VS Code and GitHub rendering. Default: true.
---@field compact_same_shapes boolean? Collapse blank lines between consecutive same-shape entries (bold pairs, link lists, bullet lists). Default: true.
---@field max_width integer|false? Cap hover float width in columns. Set to false to defer to Neovim's default. Default: 80.
---@field wrap boolean? Soft-wrap long lines inside the hover float. Default: true.
---@field fence_indented_code string|false? Wrap 4-space-indented code blocks in fences of the given language (e.g. `"elixir"`) so syntax highlighters can pick them up. LSPs like Expert emit example blocks as indented code without fences. Default: false.
---@field per_client table<string, reflow.Options>? Per-LSP-client option overrides. Keys are client names (e.g. `"expert"`); values are options merged over the defaults when that client produces a hover. Requires `patch_hover_handler` (installed by `setup`).

---@type reflow.Options
local defaults = {
  pad_fences = true,
  pad_headings = true,
  compact_same_shapes = true,
  max_width = 80,
  wrap = true,
  fence_indented_code = false,
}

-- A line that *starts* a new block and cannot be appended to the previous
-- line. List items and blockquote markers are here (they start a block)
-- but are NOT in `ends_current_block` — that's how lazy continuation works.
local function starts_new_block(line)
  if line:match('^%s*$') then return true end                              -- blank
  if line:match('^%s*#+%s') or line:match('^%s*#+$') then return true end  -- ATX heading
  if line:match('^%s*[%-%*%+]%s') then return true end                     -- bullet list
  if line:match('^%s*%d+[%.%)]%s') then return true end                    -- ordered list
  if line:match('^%s*>') then return true end                              -- blockquote
  if line:match('^%s*|') then return true end                              -- table row
  if line:match('^%s*```') then return true end                            -- fence
  if line:match('^    ') or line:match('^\t') then return true end         -- indented code
  if line:match('^%s*[%-%*_][%-%*_%s]*$') then return true end             -- horizontal rule
  return false
end

-- A line that *closes* its block and cannot have text appended to it.
-- List items and blockquotes deliberately do NOT close — their continuation
-- lines should reflow into them (CommonMark lazy continuation).
local function ends_current_block(line)
  if line:match('^%s*$') then return true end
  if line:match('^%s*#+%s') or line:match('^%s*#+$') then return true end
  if line:match('^%s*|') then return true end
  if line:match('^%s*[%-%*_][%-%*_%s]*$') then return true end
  if line:match('^%s*```') then return true end
  return false
end

-- CommonMark hard line break: trailing `  ` or `\`.
local function hard_break(line)
  return line:match('  $') ~= nil or line:match('\\$') ~= nil
end

-- Map Kramdown-style admonition classes to GitHub alert types that
-- markview.nvim already knows how to render (with icons, colors, borders).
local admonition_map = {
  error   = 'ERROR',
  warning = 'WARNING',
  info    = 'INFO',
  tip     = 'TIP',
  neutral = 'QUOTE',
}

-- "Shape" of a line, used to decide whether to compact blanks between it
-- and its neighbor. Two lines of the same shape stack tightly; different
-- shapes keep a blank separator.
local function line_shape(line)
  if line:match('^%s*%*%*') then return 'bold' end
  if line:match('^%s*%[') then return 'link' end
  if line:match('^%s*[%-%*%+]%s') then return 'list' end
  if line:match('^%s*%d+[%.%)]%s') then return 'olist' end
  return nil
end

-- Optional pre-pass: wrap CommonMark indented code blocks (4-space or
-- tab) in fenced blocks of the given language. Useful for LSPs that
-- emit example blocks as indented code instead of fences (e.g. Expert,
-- which puts Elixir examples under "## Example" as plain indentation).
-- Skipped entirely when `lang` is false/nil.
--
-- Only runs on indented blocks that begin after a blank line (or at
-- document start), matching the CommonMark definition. Indented content
-- that follows prose is lazy continuation and passes through unchanged.
-- Internal blank lines inside a code block stay inside the fence;
-- trailing blanks stay outside as paragraph separators.
local function pass_fence_indented(lines, lang)
  if not lang then return lines end

  local out = {}
  local in_fence = false
  local code_buf = nil      -- accumulated indented lines, or nil
  local trailing_blanks = nil -- blanks after last indented line, tentative

  local function flush()
    if not code_buf then return end
    table.insert(out, '```' .. lang)
    for _, l in ipairs(code_buf) do
      -- Strip a single leading 4-space or tab indent. Deeper indents
      -- (8-space nested blocks) retain their extra indentation inside
      -- the fence.
      local stripped = l:gsub('^    ', '', 1):gsub('^\t', '', 1)
      table.insert(out, stripped)
    end
    table.insert(out, '```')
    code_buf = nil
  end

  local function flush_trailing_blanks()
    if not trailing_blanks then return end
    for _, b in ipairs(trailing_blanks) do table.insert(out, b) end
    trailing_blanks = nil
  end

  for _, chunk in ipairs(lines) do
    for _, line in ipairs(vim.split(chunk, '\n', { plain = true })) do
      local is_fence = line:match('^%s*```') ~= nil
      local is_indented = line:match('^    ') or line:match('^\t')
      local is_blank = line:match('^%s*$') ~= nil

      if is_fence then
        flush()
        flush_trailing_blanks()
        in_fence = not in_fence
        table.insert(out, line)
      elseif in_fence then
        table.insert(out, line)
      elseif is_indented then
        if code_buf then
          -- Continue existing block; absorb any tentative trailing blanks
          -- as internal blanks.
          if trailing_blanks then
            for _, b in ipairs(trailing_blanks) do table.insert(code_buf, b) end
            trailing_blanks = nil
          end
          table.insert(code_buf, line)
        else
          -- A new indented block is valid if preceded by a block-ending
          -- line (blank, heading, table row, fence close, HR) or at
          -- document start. When preceded by prose, the indent is lazy
          -- paragraph continuation, not a code block — pass through.
          --
          -- Expert emits `## Examples\n    iex> …` with no blank between
          -- the heading and the code; CommonMark allows this because
          -- headings close their own block.
          local prev = out[#out]
          if not prev or ends_current_block(prev) then
            code_buf = { line }
          else
            table.insert(out, line)
          end
        end
      elseif is_blank then
        if code_buf then
          trailing_blanks = trailing_blanks or {}
          table.insert(trailing_blanks, line)
        else
          table.insert(out, line)
        end
      else
        -- Non-indented non-blank: ends any current indented block.
        flush()
        flush_trailing_blanks()
        table.insert(out, line)
      end
    end
  end
  flush()
  flush_trailing_blanks()
  return out
end

-- Pre-pass: clean up markup artifacts and rewrite Kramdown-style
-- admonition blockquotes into GitHub alert syntax so markview.nvim
-- renders them with colored borders/icons.
--
--   > #### Error {: .error}     →  > [!ERROR]
--   >                               >
--   > Body text                     > Body text
--
-- The heading line is replaced with a `[!TYPE]` callout marker. If the
-- heading text differs from the type label (e.g. `#### Watch out {: .warning}`)
-- it becomes the callout title: `> [!WARNING] Watch out`.
--
-- Also strips HTML tab comments (`<!-- tabs-open -->`, `<!-- tabs-close -->`)
-- and collapses surrounding blank lines so they don't leave visual gaps.
local function pass_admonitions(lines)
  local out = {}
  for _, line in ipairs(lines) do
    -- Strip tab-group HTML comments (used by some doc generators).
    if line:match('^%s*<!%-%-%s*tabs%-[oc]') then
      -- Drop the comment line. If the previous line in `out` is blank
      -- and would now abut nothing useful, leave it for now — the
      -- compact pass (or a later blank) will tidy it up.
    else
      -- Match: optional leading `>` + optional `#`s + title + `{: .class}`
      local prefix, title, class =
        line:match('^(%s*>%s*)#+%s+(.-)%s*{:%s*%.(%w+)%s*}%s*$')
      if prefix and admonition_map[class] then
        local alert_type = admonition_map[class]
        -- If the title is just the type name (case-insensitive), omit the
        -- custom title so markview uses its default label + icon.
        if title:lower() == class then
          table.insert(out, prefix .. '[!' .. alert_type .. ']')
        else
          table.insert(out, prefix .. '[!' .. alert_type .. '] ' .. title)
        end
      else
        table.insert(out, line)
      end
    end
  end
  return out
end

-- First pass: join soft-wrapped paragraph lines. Fence state tracked so
-- code block interiors pass through untouched. If `pad_fences` is on,
-- inject a blank line *before* opening fences so renderers can cleanly
-- conceal the fence markers. After closing fences, eat one blank line —
-- markview conceals the ``` into an empty-looking line, so any real
-- blank after it creates a visual double gap.
local function pass_join(lines, opts)
  local out = {}
  local in_fence = false
  local eat_blank_after_fence = false

  for _, chunk in ipairs(lines) do
    -- Servers sometimes pass a single string with embedded newlines.
    for _, line in ipairs(vim.split(chunk, '\n', { plain = true })) do
      -- After a closing fence, skip one blank line so the concealed
      -- ``` doesn't stack with it visually.
      if eat_blank_after_fence then
        eat_blank_after_fence = false
        if line:match('^%s*$') then goto continue end
      end

      if line:match('^%s*```') then
        if opts.pad_fences and not in_fence then
          local prev = out[#out]
          if prev and not prev:match('^%s*$') then
            table.insert(out, '')
          end
        end
        if in_fence then eat_blank_after_fence = true end
        in_fence = not in_fence
        table.insert(out, line)
      elseif in_fence then
        table.insert(out, line)
      else
        local prev = out[#out]
        -- ATX headings without a preceding blank line render as a wall of
        -- text against the prior paragraph. CommonMark doesn't require
        -- the blank, but GitHub/VS Code/most renderers show one; we
        -- match that visual convention by injecting one when needed.
        if opts.pad_headings
          and (line:match('^%s*#+%s') or line:match('^%s*#+$'))
          and prev and not prev:match('^%s*$')
        then
          table.insert(out, '')
          prev = ''
        end
        if prev
          and not starts_new_block(line)
          and not ends_current_block(prev)
          and not hard_break(prev)
        then
          out[#out] = prev .. ' ' .. line:gsub('^%s+', '')
        else
          table.insert(out, line)
        end
      end
      ::continue::
    end
  end

  return out
end

-- Second pass: compact blank-line runs. Between consecutive same-shape
-- entries (e.g. `**Key:** val` pairs, `[Link](url)` entries, bullet
-- items), drop all blanks so they stack tightly. Between different
-- shapes or before plain prose, keep exactly one blank line.
local function pass_compact(lines)
  local out = {}
  local i = 1
  while i <= #lines do
    if lines[i]:match('^%s*$') then
      local blank_end = i
      while blank_end <= #lines and lines[blank_end]:match('^%s*$') do
        blank_end = blank_end + 1
      end
      local above = out[#out]
      local below = lines[blank_end]

      if below and below:match('^%s*[%w]') then
        table.insert(out, '')
      else
        local sa = above and line_shape(above)
        local sb = below and line_shape(below)
        if sa and sb and sa == sb then
          -- drop all blanks
        else
          table.insert(out, '')
        end
      end
      i = blank_end
    else
      table.insert(out, lines[i])
      i = i + 1
    end
  end
  return out
end

---Reflow markdown lines. Pure function — no side effects, safe to call on
---any source (LSP hovers, file contents, pasted text).
---@param lines string[]
---@param opts reflow.Options?
---@return string[]
function M.reflow(lines, opts)
  opts = vim.tbl_extend('force', defaults, opts or {})
  local fenced = pass_fence_indented(lines, opts.fence_indented_code)
  local admonitioned = pass_admonitions(fenced)
  local joined = pass_join(admonitioned, opts)
  if opts.compact_same_shapes then
    return pass_compact(joined)
  end
  return joined
end

-- Idempotence guard. Stored in module state because Lua functions
-- aren't indexable (can't hang a flag on the wrapper itself). Module
-- state is fine — the patch target is also module-level mutable
-- (vim.lsp.util), so the lifetimes match.
local patched_preview = false

-- Resolve the effective option set by merging defaults + base opts +
-- any matching `per_client` override.
--
-- Identifying which LSP produced a hover is awkward: `open_floating_preview`
-- is called from async handler callbacks where the current buffer isn't
-- guaranteed to be the source. Hooking `vim.lsp.handlers['textDocument/hover']`
-- doesn't work either — recent Neovim's `vim.lsp.buf.hover` bypasses it.
--
-- Pragmatic compromise: scan all active clients (across all buffers).
-- If any client's name matches a `per_client` key, apply those overrides.
-- This assumes the user configures per_client keys for LSPs they actually
-- run (e.g. "expert" = Elixir LSP), and that if such an LSP is running
-- at all, its hover-formatting quirks are worth compensating for globally.
-- Multi-language setups with overlapping LSPs should use narrower config.
local function resolve_opts(base)
  local merged = vim.tbl_extend('force', defaults, base or {})
  if not merged.per_client then return merged end

  local get_clients = vim.lsp.get_clients or vim.lsp.get_active_clients
  for _, client in ipairs(get_clients()) do
    local override = merged.per_client[client.name]
    if override then
      return vim.tbl_extend('force', merged, override)
    end
  end
  return merged
end

---Monkey-patch `vim.lsp.util.open_floating_preview` so markdown hover
---contents are reflowed before the float buffer is populated. This is the
---single choke-point all LSP hovers route through, so one patch covers
---every client plus third-party callers (snacks.picker, trouble.nvim).
---
---Only intervenes when `syntax == 'markdown'` — plain-text and
---language-specific previews (rust-analyzer type expansions, etc.) pass
---through untouched.
---
---Idempotent: calling this multiple times wraps only once.
---@param opts reflow.Options?
-- Captures the most recent invocation of the patched open_floating_preview
-- wrapper so the state can be introspected via `M.inspect()` — useful for
-- debugging why a per_client override didn't fire or which clients were
-- visible at hover time. Kept minimal; not meant for production logging.
---@class reflow.LastInvocation
---@field syntax string|nil
---@field client_names string[]
---@field matched_client string|nil
---@field resolved_opts table
---@field contents_in string[]|string|nil
---@field contents_out string[]|nil
M.last = nil

function M.patch_lsp_hover(opts)
  if patched_preview then return end
  patched_preview = true

  local orig = vim.lsp.util.open_floating_preview
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.lsp.util.open_floating_preview = function(contents, syntax, winopts, ...)
    local resolved = resolve_opts(opts)

    -- Capture diagnostic snapshot before mutation, so `inspect()` can show
    -- both what arrived and what we produced.
    local get_clients = vim.lsp.get_clients or vim.lsp.get_active_clients
    local names = {}
    for _, c in ipairs(get_clients()) do table.insert(names, c.name) end
    local matched = nil
    if resolved.per_client then
      for _, n in ipairs(names) do
        if resolved.per_client[n] then matched = n; break end
      end
    end
    local contents_in = type(contents) == 'table' and vim.deepcopy(contents) or contents

    if syntax == 'markdown' then
      -- Recent Neovim occasionally passes `contents` as a single string.
      -- Split into lines so the reflow pass can operate line-by-line.
      if type(contents) == 'string' then
        contents = vim.split(contents, '\n', { plain = true })
      end
      if type(contents) == 'table' then
        contents = M.reflow(contents, resolved)
      end
    end

    M.last = {
      syntax = syntax,
      client_names = names,
      matched_client = matched,
      resolved_opts = resolved,
      contents_in = contents_in,
      contents_out = type(contents) == 'table' and contents or nil,
    }
    -- Inject width/wrap defaults without clobbering explicit caller values.
    winopts = winopts or {}
    if resolved.max_width and winopts.max_width == nil then
      winopts.max_width = resolved.max_width
    end
    if resolved.wrap and winopts.wrap == nil then
      winopts.wrap = resolved.wrap
    end
    return orig(contents, syntax, winopts, ...)
  end
end

---Print a human-readable summary of the most recent hover interception,
---including which LSPs were visible, which (if any) matched a
---`per_client` override, and the options that ended up resolved.
---Usage: trigger a hover, then `:lua require('reflow-markdown').inspect()`.
function M.inspect()
  if not M.last then
    print('reflow-markdown: no hover has been intercepted yet')
    return
  end
  local lines = {
    'syntax:         ' .. tostring(M.last.syntax),
    'clients seen:   ' .. table.concat(M.last.client_names, ', '),
    'matched client: ' .. tostring(M.last.matched_client),
    'resolved opts:  ' .. vim.inspect(M.last.resolved_opts),
    '',
    'contents_in (first 30 lines):',
  }
  local function append(arr)
    if type(arr) == 'string' then
      table.insert(lines, '  [string] ' .. #arr .. ' chars')
      arr = vim.split(arr, '\n', { plain = true })
    end
    for i = 1, math.min(30, #arr) do
      table.insert(lines, string.format('  %2d │ %s', i, arr[i]))
    end
    if #arr > 30 then
      table.insert(lines, string.format('     … (%d more lines)', #arr - 30))
    end
  end
  append(M.last.contents_in or {})
  table.insert(lines, '')
  table.insert(lines, 'contents_out (first 30 lines):')
  append(M.last.contents_out or {})
  print(table.concat(lines, '\n'))
end

---@class reflow.SetupOptions : reflow.Options
---@field lsp_hover boolean? Install the LSP hover patch. Default: true.

---Convenience entry point.
---@param opts reflow.SetupOptions?
function M.setup(opts)
  opts = opts or {}
  if opts.lsp_hover ~= false then
    M.patch_lsp_hover(opts)
  end
end

return M
