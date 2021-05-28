nnoremap <leader>sr :lua require('spectre').open()<CR>

" search current word
nnoremap <leader>srw viw:lua require('spectre').open_visual()<CR>
vnoremap <leader>s :lua require('spectre').open_visual()<CR>

" search in current file
nnoremap <leader>sp viw:lua require('spectre').open_file_search()<cr>
