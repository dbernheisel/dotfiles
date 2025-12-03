vim.cmd [[
  augroup vimrcEx
    autocmd!

    " Open to last line after close
    autocmd BufReadPost *
      \ if &ft != 'gitcommit' && line("'\"") > 1 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif

    " JSON w/ comments
    autocmd FileType json syntax match Comment +\/\/.\+$+

    " Resize panes when window resizes
    autocmd VimResized * :wincmd =
  augroup END
]]

vim.cmd [[
  augroup netrwEx
    " Turn off line numbers in file tree
    autocmd FileType netrw setlocal nonumber norelativenumber
    autocmd FileType netrw setlocal colorcolumn=
  augroup END
]]

vim.cmd [[
  augroup terminalEx
    " Turn off line numbers in :terminal
    au TermOpen * setlocal nonumber norelativenumber nocursorline
    au TermOpen * set winhighlight=Normal:BlackBg
  augroup END
]]

-- Clean up buffers when switching projects
vim.api.nvim_create_autocmd('DirChanged', {
  group = vim.api.nvim_create_augroup('ProjectSwitchCleanup', { clear = true }),
  pattern = 'global',
  callback = function()
    require('dbern.buffer_cleanup').cleanup_old_buffers()
  end,
  desc = 'Clean up buffers when switching projects'
})
