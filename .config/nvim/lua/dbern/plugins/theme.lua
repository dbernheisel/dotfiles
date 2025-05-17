local M = {}

vim.cmd[[
highlight Headline1 guibg=#1e2718
highlight Headline2 guibg=#21262d
highlight CodeBlock guibg=#1c1c1c
highlight Dash guibg=#D19A66 gui=bold
highlight VertSplit ctermbg=255 guibg=bg guifg=bg
highlight BlackBg guibg=#151515
highlight NormalFloat guibg=#151515
highlight link string.special.symbol @constant
]]

M.light_mode = function()
  vim.opt.background = 'light'
  vim.cmd [[colorscheme onehalflight]]
  if vim.g.lightline then
    vim.g.lightlight.colorscheme = 'onehalflight'
  end
end

M.dark_mode = function()
  vim.opt.background = 'dark'
  vim.cmd [[colorscheme sonokai]]
  if vim.g.lightline then
    vim.g.lightlight.colorscheme = 'sonokai'
  end
end

M.to_colors = function(capture)
  local result = {}
  local info = vim.api.nvim_get_hl(0, {})[capture]

  if info then
    for _, group in pairs({"fg", "bg", "sp", "italic"}) do
      local hl = info[group]

      if type(hl) == "number" then
        table.insert(result, group..": "..("#%06X"):format(hl).."\n")
      end
    end

    if info["link"] then
      vim.list_extend(result, M.to_colors(info["link"]))
    end
  end

  return result
end

M.current_highlights = function()
  local vim_hl_groups = ' '
  local result = ''

  -- vim highlights
  local r,c = unpack(vim.api.nvim_win_get_cursor(0))
  for _, val in pairs(vim.fn.synstack(r, c)) do
    vim_hl_groups = vim_hl_groups..vim.fn.synIDattr(val, 'name') .. ' '
  end

  if vim_hl_groups == ' ' then
    result = "No VIM highlights\n"
  end

  -- treesitter highlights
  local ts_node = vim.treesitter.get_node()

  if ts_node then
    result = result.."\n**Treesitter Node**: "..ts_node:type().."\n\n"
    for _, capture in pairs(vim.treesitter.get_captures_at_cursor(0)) do
      result = result.."  * **"..capture.."**\n"
      for _, i in pairs(M.to_colors("@"..capture)) do
        result = result.."  "..i
      end
    end
  end

  vim.notify(result, "info", { id = "HlCheck" })
end

_G.light_mode = M.light_mode
_G.dark_mode = M.dark_mode
_G.current_highlights = M.current_highlights

return M
