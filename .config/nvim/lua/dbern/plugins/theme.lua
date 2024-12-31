local M = {}


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

M.current_highlights = function()
  local groups = ' '
  for _, val in pairs(vim.fn.synstack(vim.fn.line('.'), vim.fn.col('.'))) do
    groups = groups..vim.fn.synIDattr(val, 'name') .. ' '
  end

  if groups == ' ' then
    print 'none'
  else
    print(groups)
  end
end

_G.light_mode = M.light_mode
_G.dark_mode = M.dark_mode
_G.current_highlights = M.current_highlights

return M
