" General
set nocompatible
if has('mac')
  set clipboard=unnamed
else
  set clipboard=unnamedplus " allow yanks to go to system clipboard
endif
set title                   " set tab title
set splitbelow              " open splits below current
set splitright              " open splits to the right of current
set laststatus=2            " always
set encoding=utf-8
set noshowmode

set mouse=a                 " Disable mouse

" Generally configure tabs to 2, and convert to spaces
set tabstop=2
set backspace=2
set softtabstop=2
set expandtab
set shiftwidth=2
set shiftround
set nojoinspaces

" Highlight character that marks where line is too long
set textwidth=80
set colorcolumn=+1

" Show the in-process keys for a command
set showcmd

" Backups
set nobackup
set nowritebackup
set noswapfile

" Turn off linewise up and down movements
nmap j gj
nmap k gk

" Turn on rendering whitespace
set listchars+=trail:·,precedes:←,extends:→,tab:¬\ ,nbsp:+,conceal:※
set list

" Turn on undo file so I can undo even after closing a file
silent !mkdir -p ~/.config/nvim/undo > /dev/null 2>&1

set undofile
set undodir=~/.config/nvim/undo

" Set map key to space
let mapleader="\<space>"
let g:maplocalleader='\\'

" Set searching to highlighting, incrementally, and smartcase search
set hlsearch
set incsearch
set ignorecase
set smartcase
map <silent> <CR> :nohl<CR>

function! ModernTerminal()
  if $TERM_PROGRAM == "iTerm.app" || $TERMINFO =~ "kitty\.app" || $TERMINFO =~ "kitty/terminfo"
    return 1
  else
    return 0
  endif
endfunction

if ModernTerminal()
  " Turn on 24bit color
  set termguicolors
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  let g:truecolor = 1
else
  let g:truecolor = 0
endif

" Automatically :write before running commands
set autowrite

" Map keys for moving between splits
nnoremap <C-H> <C-W><C-H>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>

" Disable Documentation Lookup
map K <Nop>

" Get off my lawn
imap <Up> <nop>
imap <Down> <nop>
imap <Left> <nop>
imap <Right> <nop>

" Make semicolon the same as colon
map ; :

" jj maps to Esc while in insert mode
inoremap jj <Esc>

" Shortcuts for editing vimrc. I do it too much
nnoremap <leader>ev :vsplit $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>
nnoremap <leader>c :<c-u>CocList commands<CR>

" Set lines and number gutter
set cursorline " turn on row highlighting where cursor is
set ruler      " turn on ruler information in statusline

" Set number gutter
set number

" Switch between the last two files
nnoremap <leader><leader> <c-^>

if filereadable(expand("~/.config/nvim/plugs.vim"))
  source ~/.config/nvim/plugs.vim
endif

nmap <leader>b :call ToggleFileTree()<CR>
" Don't fuck up the icons on reloading this file
function! ToggleFileTree()
  if exists("g:loaded_webdevicons")
    if exists("g:NERDTree")
      call webdevicons#refresh()
    endif
  endif
  :NERDTreeToggle
endfun
nmap <leader>/ <leader>c<space>
vmap <leader>/ <leader>c<space>

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

function! OpenTermV(...)
  let g:neoterm_size = 80
  let l:command = a:1 == '' ? 'pwd' : a:1
  execute 'vert T '.l:command
endfunction

function! OpenTermH(...)
  let g:neoterm_size = 10
  let l:command = a:1 == '' ? 'pwd' : a:1
  execute 'belowright T '.l:command
endfunction

command! -nargs=? VT call OpenTermV(<q-args>)
command! -nargs=? HT call OpenTermH(<q-args>)

function! RunTest(cmd)
  exec a:cmd
endfunction

function! RunTestSuite()
  Tclear
  if filereadable('bin/test_suite')
    T echo 'bin/test_suite'
    T bin/test_suite
  elseif filereadable("bin/test")
    T echo 'bin/test'
    T bin/test
  else
    TestSuite
  endif
endfunction
nmap <silent> <leader>t :call RunTest('TestNearest')<CR>
nmap <silent> <leader>T :call RunTest('TestFile')<CR>
nmap <silent> <leader>a :call RunTestSuite()<CR>
nmap <silent> <leader>l :call RunTest('TestLast')<CR>
nmap <silent> <leader>g :call RunTest('TestVisit')<CR>

nnoremap <C-P> :Files<CR>
nnoremap <leader>f :RipGrep<Space>
if executable('fzf')
  if executable('/home/linuxbrew/.linuxbrew/bin/fzf')
    set rtp+=/home/linuxbrew/.linuxbrew/bin/fzf
  endif

  if executable('/usr/local/opt/fzf')
    set rtp+=/usr/local/opt/fzf
  endif

  if executable('/usr/bin/fzf')
    set rtp+=/usr/bin/fzf
  endif

  set grepprg=rg\ --vimgrep   " use ripgrep
  command! -bang -nargs=* RipGrep call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/**/*" --glob "!.elixir_ls/**/*" --glob "!node_modules/**/*" --glob "!_build/**/*" --glob "!tags" --glob "!priv/static/**/*" --glob "!bower_components/**/*" --glob "!storage/**/*" --glob "!tmp/**/*" --glob "!coverage/**/*" --glob "!deps/**/*" --glob "!.hg/**/*" --glob "!.svn/**/*" --glob "!.sass-cache/**/*" --glob "!public/**/*" --glob "!*.cache" --color "always" '.shellescape(<q-args>), 1, <bang>0)
endif

function! LightlineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightlineFileencoding()
  return winwidth(0) > 70 ? &fileencoding : ''
endfunction

function! LightlineFiletype()
  return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

"============ COC Config

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <leader>rn CocCommand document.renameCurrentWord

nnoremap <silent> K :call <SID>show_documentation()<cr>

function! s:show_documentation()
  if (index(['vim', 'help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

command! -nargs=0 Format :call CocActionAsync('format')
command! -nargs=0 Prettier :CocCommand prettier.formatFile
command! -nargs=0 OR :call CocActionAsync('runCommand', 'editor.action.organizeImport')
hi CocCursorRange guibg=#b16286 guifg=#ebdbb2
nmap <leader>rn <Plug>(coc-rename)

augroup cocEx
  " Highlight symbol under cursor on CursorHold
  autocmd CursorHold * silent call CocActionAsync('highlight')

  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup END

"============

nnoremap <leader>cal :Calendar -view=year -split=horizontal -position=bottom -height=12<cr>

" Theme
syntax on

function! LightMode()
  set background=light
  colorscheme onehalflight
  let g:lightline.colorscheme='onehalflight'
endfunction
nmap <leader>lm :call LightMode()<cr>

function! DarkMode()
  set background=dark
  colorscheme monokai-phoenix
  let g:lightline.colorscheme='wombat'
  " Transparent Backgrounds
  hi Normal guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE
endfunction
nmap <leader>dm :call DarkMode()<cr>

if filereadable(expand("~/.config/nvim/terminal.vim"))
  source ~/.config/nvim/terminal.vim
endif

:call DarkMode()

if ModernTerminal()
  " Comments should be italics
  hi Comment gui=italic
endif

augroup vimrcEx
  autocmd!

  " Open to last line after close
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  " Set syntax highlighting
  autocmd BufNewFile,BufRead Procfile,Brewfile setf ruby
  autocmd BufNewFile,BufRead *.md setf markdown
  autocmd BufNewFile,BufRead *.drab setf eelixir
  autocmd BufNewFile,BufRead *.arb setf ruby
  autocmd BufNewFile,BufRead irbrc setf ruby
  autocmd BufNewFile,BufRead pryrc setf ruby
  autocmd BufNewFile,BufRead *.jsonc setf json
  autocmd FileType json syntax match Comment +\/\/.\+$+

  " Remove trailing whitespace on save
  autocmd BufWritePre * :%s/\s\+$//e

  " Resize panes when window resizes
  autocmd VimResized * :wincmd =
augroup END

augroup nerdtreeEx
  autocmd!
  autocmd FileType nerdtree setlocal nocursorline nonumber norelativenumber
  autocmd FileType nerdtree setlocal colorcolumn=
augroup end

augroup netrwEx
  " Turn off line numbers in file tree
  autocmd FileType netrw setlocal nonumber norelativenumber
  autocmd FileType netrw setlocal colorcolumn=
augroup END

filetype on

