local terminal = require('dbern.plugins.fterm')
local M = {}

M.test_elixir_app = function(cmd)
  if cmd == "mix test" and vim.fn.isdirectory("apps") == 1 then
    local _, _, current_app = string.find(vim.fn.expand("%"), "apps/(%g-)/")
    local testdir = vim.fn.resolve("apps/" .. current_app .. "/test")
    if vim.fn.isdirectory(testdir) then
      return cmd .. ' ' .. vim.fn.resolve("apps/" .. current_app .. "/test")
    end
  end
  return cmd
end

_G.run_test_suite = function()
  if vim.fn.filereadable('bin/test_suite') == 1 then
    terminal.run_cmd('bin/test_suite')
  elseif vim.fn.filereadable('bin/test') == 1 then
    terminal.run_cmd('bin/test')
  elseif vim.fn.filereadable('bin/test') == 1 then
    terminal.run_cmd('bin/test')
  else
    vim.cmd('TestSuite')
  end
end

M.setup = function()
  vim.cmd [[
    function! FTermStrategy(cmd)
      call v:lua.run_cmd(a:cmd)
    endfunction

    let g:test#plugin_path = fnamemodify('~/.config/kitty', ':p:h')
    let g:test#custom_strategies = {
      \ 'FTerm': function('FTermStrategy'),
    \ }
    let g:test#strategy = 'kitty'

    let test#shell#bats#options = {
          \ 'nearest': '-t'
          \ }
  ]]

  vim.api.nvim_set_keymap('n', '<leader>t', ':TestNearest<cr>', { silent = true })
  vim.api.nvim_set_keymap('n', '<leader>T', ':TestFile<cr>', { silent = true })
  vim.api.nvim_set_keymap('n', '<leader>l', ':TestLast<cr>', { silent = true })
  vim.api.nvim_set_keymap('n', '<leader>a', ':call v:lua.run_test_suite()<cr>', { silent = true })
end

return M
