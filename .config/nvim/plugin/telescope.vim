lua require("dbern.telescope")

silent! !git rev-parse --is-inside-work-tree
if v:shell_error == 0
  nnoremap <silent> <c-p> :lua require('dbern.telescope').find_git_files()<CR>
else
  nnoremap <silent> <c-p> :lua require('dbern.telescope').find_files()<CR>
endif

nnoremap <silent> <leader>f :lua require('telescope.builtin').grep_string({ search = vim.fn.input("> ")})<CR>
nnoremap <silent> <leader>cw :lua require('telescope.builtin').grep_string({ search = vim.fn.expand("<cword>") })<CR>

nnoremap <silent> <leader>b :lua require('dbern.telescope').file_browser()<CR>

nnoremap <silent> <leader>ev :lua require('dbern.telescope').search_vimrc()<CR>
nnoremap <silent> <leader>ed :lua require('dbern.telescope').search_dotfiles()<CR>
nnoremap <silent> <leader>el :lua require('dbern.telescope').search_local()<CR>

nnoremap <silent> <leader>gb :lua require('dbern.telescope').git_branches()<CR>

highlight TelescopeBorder         guibg=Black guifg=Grey
highlight TelescopePromptBorder   guibg=Black guifg=Grey
highlight TelescopeResultsBorder  guibg=Black guifg=Grey
highlight TelescopePreviewBorder  guibg=Black guifg=Grey
