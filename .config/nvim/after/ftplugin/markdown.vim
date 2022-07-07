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

" If the buffer is in the wiki
if(expand('%:p:h')=~"vimwiki")
  nmap <buffer> <CR> <Plug>VimwikiFollowLink
  nmap <buffer> <Backspace> <Plug>VimwikiGoBackLink
else
  " Basically unmap it
  nmap <buffer> <F14> <Plug>VimwikiFollowLink
  nmap <buffer> <F15> <Plug>VimwikiGoBackLink
endif

" Distraction-free writing mode
function! s:goyo_enter()
  " turn off cursor-line-highlight auto-indent, whitespace, and in-progress
  " commands
  setlocal noai noruler nolist noshowcmd nocursorline nospell
  setlocal fillchars=eob:\ "don't trim

  Limelight  " Focus on the current paragraph, dim the others
  SoftPencil " Turn on soft breaks
  silent Wordy weak " Highlight weak words
  call NullStopLsp()
  echo ' '
endfunction

function! s:goyo_leave()
  setlocal ai list showcmd cursorline

  Limelight!
  NoPencil
  silent NoWordy
  echo ' '
endfunction

command! Present Goyo | Limelight!
autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()
nmap <leader>df :Goyo<CR>
