local M = {}

vim.g.sonokai_transparent_background = true
vim.g.sonokai_enable_italic = false
vim.g.sonokai_disable_italic_comment = true
vim.g.sonokai_better_performance = true
-- Comment when italics are disabled
-- vim.cmd [[let &t_ZH="\e[3m"]]
-- vim.cmd [[let &t_ZR="\e[23m"]]

M.setup = function()
  vim.api.nvim_set_keymap('n', '<leader>dm', ':call v:lua.dark_mode()<cr>', {})
  vim.api.nvim_set_keymap('n', '<leader>lm', ':call v:lua.light_mode()<cr>', {})
  vim.api.nvim_set_keymap('', '<f10>', ':call v:lua.current_highlights()<cr>', {})
  M.dark_mode()
end

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

