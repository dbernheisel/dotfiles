" Distraction-free writing mode
let g:pencil#textwidth = 80
let g:goyo_width = 80
let g:vim_markdown_frontmatter = 1

" Enable spellchecking for Markdown
setlocal nolist
setlocal spell
setlocal foldlevel=999
setlocal nocindent
setlocal textwidth=80
setlocal colorcolumn=+1

" Distraction-free writing mode
function! s:goyo_enter()
  " light theme
  setlocal background=light
  colorscheme chroma

  " turn off cursor-line-highlight auto-indent, whitespace, and in-progress
  " commands
  setlocal noai nolist noshowcmd nocursorline

  " turn on autocorrect
  setlocal spell complete+=s

  Limelight  " Focus on the current paragraph, dim the others
  SoftPencil " Turn on soft breaks
  Wordy weak " Highlight weak words
endfunction

function! s:goyo_leave()
  setlocal cursorline
  setlocal showcmd list ai
  setlocal nospell complete-=s
  setlocal background=dark
  Limelight!
  NoPencil
  NoWordy
  colorscheme monokai-phoenix
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()
nmap <leader>df :Goyo<CR>
