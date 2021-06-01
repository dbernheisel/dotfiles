lua require("dbern.telescope")

nnoremap <c-p> :lua require('telescope.builtin').git_files({previewer = false})<CR>
nnoremap <leader>f :lua require('telescope.builtin').grep_string({ search = vim.fn.input("> ")})<CR>
nnoremap <leader>cw :lua require('telescope.builtin').grep_string({ search = vim.fn.expand("<cword>") })<CR>

nnoremap <leader>b :lua require('dbern.telescope').file_browser()<CR>

nnoremap <leader>ev :lua require('dbern.telescope').search_vimrc()<CR>
nnoremap <leader>ed :lua require('dbern.telescope').search_dotfiles()<CR>
nnoremap <leader>el :lua require('dbern.telescope').search_local()<CR>

nnoremap <leader>gb :lua require('dbern.telescope').git_branches()<CR>
