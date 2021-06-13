lua require("dbern.telescope")

silent! !git rev-parse --is-inside-work-tree
if v:shell_error == 0
  nnoremap <silent> <c-p> :lua require('dbern.telescope').find_git_files()<CR>
else
  nnoremap <silent> <c-p> :lua require('dbern.telescope').find_files()<CR>
endif

nnoremap <silent> <leader>f :lua require('telescope.builtin').grep_string({ search = vim.fn.input("> ")})<CR>
nnoremap <silent> <leader>cw :lua require('telescope.builtin').grep_string({ search = vim.fn.expand("<cword>") })<CR>

nnoremap <leader>b :lua require('dbern.telescope').file_browser()<CR>

nnoremap <leader>ev :lua require('dbern.telescope').search_vimrc()<CR>
nnoremap <leader>ed :lua require('dbern.telescope').search_dotfiles()<CR>
nnoremap <leader>el :lua require('dbern.telescope').search_local()<CR>

nnoremap <leader>gb :lua require('dbern.telescope').git_branches()<CR>
