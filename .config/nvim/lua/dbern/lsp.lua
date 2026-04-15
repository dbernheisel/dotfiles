local a = vim.api
local lsputil = require("vim.lsp.util")
local hasFzf, _Fzf = pcall(require, "fzf-lua")

local M = {}


M.on_attach = function(args)
  local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
  local bufnr = args.buf

  -- if client:supports_method('textDocument/completion') then
  --   vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
  -- end

  if client and client:supports_method "textDocument/codeLens" and client.name ~= "markdown_oxide" then
    vim.lsp.codelens.enable()
  end

  local kmp = function(lhs, rhs, desc)
    a.nvim_buf_set_keymap(bufnr, 'n', lhs, rhs, { noremap = true, silent = true, desc = desc })
  end

  kmp('K', '<cmd>lua vim.lsp.buf.hover()<cr>', "Show help")
  kmp('<c-space>', '<cmd>lua vim.lsp.buf.signature_help()<cr>', "Show signature help")
  if _G.Snacks then
    kmp('gd', '<cmd>lua Snacks.picker.lsp_definitions()<cr>', "Goto definition")
    kmp('gt', '<cmd>lua Snacks.picker.lsp_type_definitions()<cr>', "Goto type definition")
    kmp('gi', '<cmd>lua Snacks.picker.lsp_implementations()<cr>', "Goto implementation")
    kmp('<leader>gr', '<cmd>lua Snacks.picker.lsp_references()<cr>', "References")
    kmp('<leader>gs', '<cmd>lua Snacks.picker.lsp_symbols()<cr>', "Document Symbols")
    kmp('<leader>gw', '<cmd>lua Snacks.picker.lsp_workspace_symbols()<cr>', "Workspace symbols")
    if hasFzf then
      kmp('<leader>gi', '<cmd>FzfLua lsp_incoming_calls<cr>', "Incoming calls")
      kmp('<leader>go', '<cmd>FzfLua lsp_outgoing_calls<cr>', "Outgoing calls")
    end
  elseif hasFzf then
    kmp('gd', '<cmd>lua <cmd>FzfLua lsp_definitions()<cr>', "Goto definition")
    kmp('gt', '<cmd>lua <cmd>FzfLua lsp_typedefs()<cr>', "Goto type definition")
    kmp('gi', '<cmd>lua <cmd>FzfLua lsp_implementations()<cr>', "Goto implementation")
    kmp('<leader>gr', '<cmd>FzfLua lsp_references<cr>', "References")
    kmp('<leader>gs', '<cmd>FzfLua lsp_document_symbols<cr>', "Document Symbols")
    kmp('<leader>gw', '<cmd>FzfLua lsp_workspace_symbols<cr>', "Workspace symbols")
    kmp('<leader>gi', '<cmd>FzfLua lsp_incoming_calls<cr>', "Incoming calls")
    kmp('<leader>go', '<cmd>FzfLua lsp_outgoing_calls<cr>', "Outgoing calls")
  else
    kmp('<leader>gr', '<cmd>lua vim.lsp.buf.references()<cr>', "LSP References")
    kmp('<leader>gs', '<cmd>lua vim.lsp.buf.document_symbol()<cr>', "Document Symbols")
    kmp('<leader>gw', '<cmd>lua vim.lsp.buf.workspace_symbol()<cr>', "Workspace symbols")
    kmp('<leader>gi', '<cmd>lua vim.lsp.buf.incoming_calls()<cr>', "Incoming calls")
    kmp('<leader>go', '<cmd>lua vim.lsp.buf.outgoing_calls()<cr>', "Outgoing calls")
  end

  kmp('<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', "Code actions")
  kmp('<leader>cl', '<cmd>lua vim.lsp.codelens.run()<cr>', "Run code lens")

  if client:supports_method("textDocument/rename") then
    kmp('<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', "Rename")
  end

  if client:supports_method('textDocument/foldingRange') then
    local win = vim.api.nvim_get_current_win()
    vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
  end

  if client:supports_method("textDocument/formatting") then
    a.nvim_buf_create_user_command(bufnr, 'Format', function()
      client:request("textDocument/formatting", lsputil.make_formatting_params(), nil, bufnr)
    end, { nargs = 0 })
  end

  -- Highlight
  if client:supports_method("textDocument/documentHighlight") then
    a.nvim_clear_autocmds({ group = M.lspHighlightAugroup, buffer = bufnr })
    a.nvim_create_autocmd("CursorHold", {
      group = M.lspHighlightAugroup,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.document_highlight()
      end,
    })
    a.nvim_create_autocmd("CursorMoved", {
      group = M.lspHighlightAugroup,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.clear_references()
      end,
    })
  end

  a.nvim_command('setlocal omnifunc=v:lua.vim.lsp.omnifunc')
end

---@param args vim.api.keyset.create_autocmd.callback_args
M.on_detach = function(args)
  local client = vim.lsp.get_client_by_id(args.data.client_id)
  if not client then return end

  local other_buffers_count = 0
  for buf_id in pairs(client.attached_buffers) do
    if buf_id ~= args.buf then
      other_buffers_count = other_buffers_count + 1
    end
  end

  if other_buffers_count == 0 then
    client:stop()
    vim.notify(
      string.format('Stopping LSP client %s (0 buffers)', client.name),
      vim.log.levels.INFO
    )
  end
end

M.setup = function()
  M.lspHighlightAugroup = vim.api.nvim_create_augroup("LspDocumentHighlight", {})

  require('reflow-markdown').setup({
    -- Expert (Elixir LSP) emits example blocks under `## Examples` as
    -- 4-space-indented CommonMark code instead of fenced blocks. Wrap
    -- them in ```elixir so markview/treesitter can syntax-highlight.
    -- Scoped to `expert` so other LSPs' indented content isn't touched.
    per_client = {
      expert = { fence_indented_code = 'elixir', strip_exdoc_autolinks = true },
    },
  })

  a.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('my.lsp.attach', {}),
    callback = M.on_attach,
    desc = "Start LSP clients"
  })

  a.nvim_create_autocmd("LspDetach", {
    group = vim.api.nvim_create_augroup("my.lsp.detach", {}),
    callback = M.on_detach,
    desc = "Stop LSP client when no buffer is attached",
  })

  -- Enable all servers defined in lsp/*.lua
  for _, file in ipairs(vim.api.nvim_get_runtime_file('lsp/*.lua', true)) do
    local name = vim.fn.fnamemodify(file, ':t:r')
    vim.lsp.enable(name)
  end

  require('colorizer').setup({'css', 'scss', 'sass', 'javascript', 'html',
    'svg', 'lua', 'vim', 'svg', 'conf', 'eelixir', 'elixir', 'heex', 'erb'})
end

return M
