lua require('dbern.terminal')

" Emulate tmux shortcuts
" Remember to use :tabclose instead of :q for zoomed terminals
nnoremap <C-A>z :$tabnew<CR>:terminal<CR>i
" nnoremap <C-A>\ :ToggleTerm size=40 direction=vertical<CR>
nnoremap <C-A>\ :80vsplit term://$SHELL<CR>i
" nnoremap <C-A>- :ToggleTerm size=12<CR>
nnoremap <C-A>- :split term://$SHELL<CR>i

nnoremap <leader>t1 <cmd>lua require('dbern.terminal').toggle_term()<CR>
nnoremap <leader>t2 <cmd>lua require('dbern.terminal').toggle_test()<CR>

augroup terminalEx
  " Turn off line numbers in :terminal
  au TermOpen * setlocal nonumber norelativenumber nocursorline
  au TermOpen * set winhighlight=Normal:BlackBg
augroup END

" Terminal Mode mappings
tnoremap <C-O> <C-\><C-N>
tnoremap <C-E> <C-\><C-N>:WinResizerStartResize<CR>
tnoremap <A-H> <C-\><C-N><C-W>h
tnoremap <A-J> <C-\><C-N><C-W>j
tnoremap <A-K> <C-\><C-N><C-W>k
tnoremap <A-L> <C-\><C-N><C-W>l
tnoremap <leader>t1 <cmd>lua require('dbern.terminal').toggle_term()<CR>
tnoremap <leader>t2 <cmd>lua require('dbern.terminal').toggle_test()<CR>
inoremap <A-H> <C-\><C-N><C-W>h
inoremap <A-J> <C-\><C-N><C-W>j
inoremap <A-K> <C-\><C-N><C-W>k
inoremap <A-L> <C-\><C-N><C-W>l
