local M = {}

vim.g.sonokai_transparent_background = true
vim.g.sonokai_enable_italic = false
vim.g.sonokai_disable_italic_comment = true
-- " Uncomment when italics are enabled
-- " let &t_ZH="\e[3m"
-- " let &t_ZR="\e[23m"

vim.g.terminal_color_0  = '#151515'
vim.g.terminal_color_1  = '#ac4142'
vim.g.terminal_color_2  = '#7e8e50'
vim.g.terminal_color_3  = '#e5b567'
vim.g.terminal_color_4  = '#6c99bb'
vim.g.terminal_color_5  = '#9f4e85'
vim.g.terminal_color_6  = '#7dd6cf'
vim.g.terminal_color_7  = '#d0d0d0'
vim.g.terminal_color_8  = '#505050'
vim.g.terminal_color_9  = '#ac4142'
vim.g.terminal_color_10 = '#7e8e50'
vim.g.terminal_color_11 = '#e5b567'
vim.g.terminal_color_12 = '#6c99bb'
vim.g.terminal_color_13 = '#9f4e85'
vim.g.terminal_color_14 = '#7dd6cf'
vim.g.terminal_color_15 = '#f5f5f5'

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

