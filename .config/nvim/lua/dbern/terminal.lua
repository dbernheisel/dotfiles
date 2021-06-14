require('FTerm').setup()

local M = {}

local test_terminal = require("FTerm.terminal"):new():setup({dimensions = { height = 0.9, width = 0.9 }})
local gen_terminal = require("FTerm.terminal"):new():setup({dimensions = { height = 0.9, width = 0.9 }})

M.toggle_term = function()
  gen_terminal:toggle()
  vim.api.nvim_win_set_option(gen_terminal.win, 'winblend', 5)
end

M.toggle_test = function()
  test_terminal:toggle()
  vim.api.nvim_win_set_option(test_terminal.win, 'winblend', 5)
end

M.run_in_test = function(opts)
  test_terminal:open()
  vim.api.nvim_win_set_option(test_terminal.win, 'winblend', 5)
  vim.api.nvim_input(opts['run'] .. "<cr>")
end

return M
