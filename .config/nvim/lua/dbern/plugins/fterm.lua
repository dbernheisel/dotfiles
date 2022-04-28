local fterm = require('FTerm')

local M = {}

local test_terminal = fterm:new({
  blend = 5,
  border = 'shadow',
  dimensions = { height = 0.9, width = 0.9 }
})

local gen_terminal = fterm:new({
  blend = 5,
  border = 'shadow',
  dimensions = { height = 0.9, width = 0.9 }
})

M.toggle_term = function()
  test_terminal:close()
  gen_terminal:toggle()
end

M.toggle_test = function()
  gen_terminal:close()
  test_terminal:toggle()
end

M.run_cmd = function(cmd)
  gen_terminal:close()
  local cancel_command = vim.api.nvim_replace_termcodes("<C-u>", true, false, true)
  test_terminal:run(cancel_command)
  test_terminal:run(cmd)
end

_G.toggle_test = M.toggle_test
_G.toggle_term = M.toggle_term
_G.run_cmd = M.run_cmd

-- Keymaps
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('n', '<leader>t1', ':call v:lua.toggle_term()<cr>', opts)
vim.api.nvim_set_keymap('n', '<leader>t2', ':call v:lua.toggle_test()<cr>', opts)
vim.api.nvim_set_keymap('t', '<leader>t1', '<c-\\><c-n>:call v:lua.toggle_term()<cr>', opts)
vim.api.nvim_set_keymap('t', '<leader>t2', '<c-\\><c-n>:call v:lua.toggle_test()<cr>', opts)
return M
