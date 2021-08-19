function! ModernTerminal()
  if $TERM_PROGRAM == "iTerm.app" || $TERMINFO =~ "kitty\.app" || $TERMINFO =~ "kitty/terminfo" || $KITTY_WINDOW_ID != "" || $SSH_CLIENT != ""
    return 1
  else
    return 0
  endif
endfunction

if ModernTerminal()
  " Turn on 24bit color
  set termguicolors

  " https://sw.kovidgoyal.net/kitty/faq.html#using-a-color-theme-with-a-background-color-does-not-work-well-in-vim
  let &t_ut=''

  " https://github.com/vim/vim/issues/993#issuecomment-255651605
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

function! LightMode()
  set background=light
  colorscheme onehalflight

  if exists('g:lightline')
    let g:lightline.colorscheme='onehalflight'
  endif

  if ModernTerminal()
    " Comments should be italics
    hi Comment gui=italic
  endif
endfunction

function! DarkMode()
  set background=dark
  colorscheme sonokai
  if exists('g:lightline')
    let g:lightline.colorscheme='sonokai'
  endif

  " Transparent Backgrounds
  if ModernTerminal()
    " Comments should be italics
    hi Comment gui=italic
  endif
endfunction

let g:sonokai_transparent_background = 1

nmap <leader>dm :call DarkMode()<cr>
nmap <leader>lm :call LightMode()<cr>

:call DarkMode()

" Find what the current highlight group is
function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

map <F10> :call SynStack()<CR>

let g:terminal_color_0  = '#151515'
let g:terminal_color_1  = '#ac4142'
let g:terminal_color_2  = '#7e8e50'
let g:terminal_color_3  = '#e5b567'
let g:terminal_color_4  = '#6c99bb'
let g:terminal_color_5  = '#9f4e85'
let g:terminal_color_6  = '#7dd6cf'
let g:terminal_color_7  = '#d0d0d0'
let g:terminal_color_8  = '#505050'
let g:terminal_color_9  = '#ac4142'
let g:terminal_color_10 = '#7e8e50'
let g:terminal_color_11 = '#e5b567'
let g:terminal_color_12 = '#6c99bb'
let g:terminal_color_13 = '#9f4e85'
let g:terminal_color_14 = '#7dd6cf'
let g:terminal_color_15 = '#f5f5f5'

hi VertSplit ctermbg=255 guibg=bg guifg=bg
hi BlackBg guibg=#151515
set fillchars+=vert:\  " don't trim
