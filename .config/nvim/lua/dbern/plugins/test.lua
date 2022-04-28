local terminal = require('dbern.plugins.fterm')

vim.cmd [[
  function! FTermStrategy(cmd)
    call v:lua.run_cmd(a:cmd)
  endfunction

  let g:test#custom_strategies = {'FTerm': function('FTermStrategy')}
  let g:test#strategy = 'FTerm'

  let test#shell#bats#options = {
        \ 'nearest': '-t'
        \ }
]]


_G.run_test_suite = function()
  if vim.fn.filereadable('bin/test_suite') then
    terminal.run_cmd('bin/test_suite')
  elseif vim.fn.filereadable('bin/test') then
    terminal.run_cmd('bin/test')
  else
    vim.fn['TestSuite']()
  end
end

vim.api.nvim_set_keymap('n', '<leader>t', ':TestNearest<cr>', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>T', ':TestFile<cr>', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>l', ':TestLast<cr>', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>a', ':call v:lua.run_test_suite()<cr>', { silent = true })
