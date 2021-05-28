lua require("dbern.telescope")

nnoremap <c-p> :lua require('telescope.builtin').git_files({previewer = false})<CR>
nnoremap <leader>f :Telescope live_grep<CR>

nnoremap <leader>ev :lua require('dbern.telescope').search_vimrc()<CR>
nnoremap <leader>ed :lua require('dbern.telescope').search_dotfiles()<CR>
nnoremap <leader>el :lua require('dbern.telescope').search_local()<CR>
nnoremap <leader>gb :lua require('dbern.telescope').git_branches()<CR>
nnoremap <leader>b :lua require('dbern.telescope').file_browser()<CR>
