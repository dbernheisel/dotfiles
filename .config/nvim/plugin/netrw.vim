augroup netrwEx
  " Turn off line numbers in file tree
  autocmd FileType netrw setlocal nonumber norelativenumber
  autocmd FileType netrw setlocal colorcolumn=
augroup END

" Netrw, make it more like a project drawer
let g:netrw_preview   = 1
let g:netrw_liststyle = 3
let g:netrw_winsize   = 30
let g:netrw_banner = 0
