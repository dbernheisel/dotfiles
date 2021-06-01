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

if has('python')
  set pyx=3
endif

set diffopt+=vertical

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

" Turn on rendering whitespace
set listchars+=trail:·,precedes:←,extends:→,tab:¬\ ,nbsp:+,conceal:※
set list

" Turn on undo file so I can undo even after closing a file
silent !mkdir -p ~/.cache/nvim/undo > /dev/null 2>&1
set undofile
set undodir=~/.cache/nvim/undo

set shortmess+=c

set hlsearch
set incsearch
set ignorecase
set smartcase

" Automatically :write before running commands
set autowrite

" Set lines and number gutter
set cursorline " turn on row highlighting where cursor is
set ruler      " turn on ruler information in statusline

" Set number gutter
set number

if executable('rg')
  set grepprg="rg --vimgrep"   " use ripgrep
endif

set redrawtime=10000
