lua require("dbern.search_replace")

nnoremap <leader>sr :lua require('dbern.search_replace').find()<CR>

" search current word
nnoremap <leader>srw :lua require('dbern.search_replace').find_word()<CR>
vnoremap <leader>s :lua require('dbern.search_replace').find_word()<CR>

" search in current file
nnoremap <leader>sp :lua require('dbern.search_replace').find_in_buffer()<cr>
