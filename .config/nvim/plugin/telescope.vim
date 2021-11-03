lua require("dbern.telescope")

let g:fzf_buffers_jump = 1
let g:fzf_layout = { 'window': { 'width': 0.95, 'height': 0.9, 'relative': v:true, 'yoffset': 1.0 } }
let g:fzf_preview_window = ['right:40%:hidden', 'ctrl-/']

nnoremap <silent> <c-p> :Files<CR>
" nnoremap <silent> <c-p> :lua require('dbern.telescope').find_files()<CR>
" nnoremap <silent> <c-f> :lua require('dbern.telescope').find_files()<CR>
" nnoremap <silent> <leader>f :lua require('telescope.builtin').grep_string({ search = vim.fn.input("> ")})<CR>
nnoremap <silent> <leader>f :Rg
" nnoremap <silent> <leader>cw :lua require('telescope.builtin').grep_string({ search = vim.fn.expand("<cword>") })<CR>

nnoremap <silent> <leader>b :lua require('dbern.telescope').file_browser()<CR>

nnoremap <silent> <leader>ev :lua require('dbern.telescope').search_vimrc()<CR>
nnoremap <silent> <leader>ed :lua require('dbern.telescope').search_dotfiles()<CR>
nnoremap <silent> <leader>el :lua require('dbern.telescope').search_local()<CR>

nnoremap <silent> <leader>gb :lua require('dbern.telescope').git_branches()<CR>

highlight TelescopeBorder         guibg=Black guifg=Grey
highlight TelescopePromptBorder   guibg=Black guifg=Grey
highlight TelescopeResultsBorder  guibg=Black guifg=Grey
highlight TelescopePreviewBorder  guibg=Black guifg=Grey
