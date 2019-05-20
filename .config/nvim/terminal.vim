augroup terminalEx
  " Turn off line numbers in :terminal
  autocmd TermOpen * setlocal nonumber norelativenumber nocursorline
augroup END

" Emulate tmux shortcuts
" Remember to use :tabclose instead of :q for zoomed terminals
nnoremap <C-A>z :-tabedit %<CR>
nnoremap <C-A>\ :80vsplit term://$SHELL -l<CR>
nnoremap <C-A>- :split term://$SHELL -l<CR>

" Terminal Mode mappings
tnoremap <C-O> <C-\><C-N>
tnoremap <C-E> <C-\><C-N>:WinResizerStartResize<CR>
tnoremap <A-H> <C-\><C-N><C-W>h
tnoremap <A-J> <C-\><C-N><C-W>j
tnoremap <A-K> <C-\><C-N><C-W>k
tnoremap <A-L> <C-\><C-N><C-W>l
inoremap <A-H> <C-\><C-N><C-W>h
inoremap <A-J> <C-\><C-N><C-W>j
inoremap <A-K> <C-\><C-N><C-W>k
inoremap <A-L> <C-\><C-N><C-W>l

let g:terminal_color_0  = '#151515'
let g:terminal_color_1  = '#ac4142'
let g:terminal_color_2  = '#7e8e50'
let g:terminal_color_3  = '#e5b567'
let g:terminal_color_4  = '#6c99bb'
let g:terminal_color_5  = '#9f4e85'
let g:terminal_color_6  = '#7dd6cf'
let g:terminal_color_7  = '#d0d0d0'
let g:terminal_color_8  = '#505050'
let g:terminal_color_9  = '#ac4142'
let g:terminal_color_10 = '#7e8e50'
let g:terminal_color_11 = '#e5b567'
let g:terminal_color_12 = '#6c99bb'
let g:terminal_color_13 = '#9f4e85'
let g:terminal_color_14 = '#7dd6cf'
let g:terminal_color_15 = '#f5f5f5'
