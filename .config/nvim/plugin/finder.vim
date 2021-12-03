lua require("dbern.finder")

let g:fzf_buffers_jump = 1
let g:fzf_layout = { 'window': { 'width': 0.95, 'height': 0.9, 'relative': v:true, 'yoffset': 1.0 } }
let g:fzf_preview_window = ['right:40%:hidden', 'ctrl-/']

silent! !git rev-parse --is-inside-work-tree
let s:git_project = v:shell_error == 0

function! g:FzfFilesSource()
  let l:base = fnamemodify(expand('%'), ':h:.:S')
  let l:finder = 'find'

  if executable('fd')
    let l:finder = 'fd -t f'
  elseif executable('fdfind')
    let l:finder = 'fdfind -t f'
  elseif executable('rg')
    let l:finder = 'rg --files'
  elseif s:git_project
    let l:finder = 'git ls-files'
  endif

  if base == '.'
    return l:finder
  elseif executable('proximity-sort')
    let l:finder = printf('%s | proximity-sort %s', l:finder, expand('%'))
    return l:finder
  else
    return l:finder
  endif
endfunction

" nnoremap <silent> <c-p> :Files<CR>
noremap <silent> <C-p> :call fzf#vim#files('', { 'source': g:FzfFilesSource(),
      \ 'options': [
      \   '--tiebreak=index'
      \  ]})<CR>

nnoremap <leader>f :Rg<space>
nnoremap <leader>F :Telescope lsp_workspace_symbols query=

" Avoiding Telescope since I'm working in a monorepo now :(
"
" nnoremap <silent> <c-p> :lua require('dbern.finder').find_files()<CR>
" nnoremap <silent> <c-f> :lua require('dbern.finder').find_files()<CR>
" nnoremap <silent> <leader>f :lua require('telescope.builtin').grep_string({ search = vim.fn.input("> ")})<CR>
" nnoremap <silent> <leader>cw :lua require('telescope.builtin').grep_string({ search = vim.fn.expand("<cword>") })<CR>

nnoremap <silent> <leader>b :lua require('dbern.finder').file_browser()<CR>
nnoremap <silent> <leader>B :lua require('dbern.finder').file_browser_from_buffer()<CR>

nnoremap <silent> <leader>ev :lua require('dbern.finder').search_vimrc()<CR>
nnoremap <silent> <leader>ed :lua require('dbern.finder').search_dotfiles()<CR>
nnoremap <silent> <leader>el :lua require('dbern.finder').search_local()<CR>
nnoremap <silent> <leader>ca :lua require('dbern.finder').code_actions()<CR>

nnoremap <silent> <leader>gb :lua require('dbern.finder').git_branches()<CR>

highlight TelescopeBorder         guibg=Black guifg=Grey
highlight TelescopePromptBorder   guibg=Black guifg=Grey
highlight TelescopeResultsBorder  guibg=Black guifg=Grey
highlight TelescopePreviewBorder  guibg=Black guifg=Grey
