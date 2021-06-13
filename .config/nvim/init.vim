" More bash-like command complete selection
cnoremap <Left> <Space><BS><Left>
cnoremap <Right> <Space><BS><Right>

" Turn off linewise up and down movements
nmap j gj
nmap k gk

map K <Nop>

" Set map key to space
let mapleader="\<space>"
let g:maplocalleader='\\'

" Set searching to highlighting, incrementally, and smartcase search
map <silent> <CR> :nohl<CR>

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

" Change Tabs
nnoremap <silent> <c-left> :tabprevious<CR>
nnoremap <silent> <c-right> :tabnext<CR>

" Make semicolon the same as colon
map ; :

" jj maps to Esc while in insert mode
inoremap jj <Esc>

" Move lines up and down
nnoremap <silent> <M-k> :move-2<CR>
nnoremap <silent> <M-j> :move+<CR>

" Indent/Outdent current line
nnoremap <silent> <M-h> <<
nnoremap <silent> <M-l> >>

" Shortcuts for editing vimrc. I do it too much
nnoremap <leader>sv :source $MYVIMRC<CR>

" Switch between the last two files
nnoremap <leader><leader> <c-^>

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

function! s:show_documentation()
  if (index(['vim', 'help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  endif
endfunction

nmap <silent> gd :call <sid>show_documentation()<cr>

nmap <leader>/ <leader>c<space>
vmap <leader>/ <leader>c<space>

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

nnoremap <leader>cal :Calendar -view=year -split=horizontal -position=bottom -height=12<cr>

function! s:DetectElixir()
  if (!did_filetype() || &filetype !=# 'elixir') && getline(1) =~# '^#!.*\<elixir\>'
    setf elixir
  endif
endfunction

augroup vimrcEx
  autocmd!

  " Open to last line after close
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  " Set syntax highlighting
  autocmd BufNewFile,BufRead *.ex,*.exs setf elixir
  autocmd BufNewFile,BufRead *.html.eex,*.html.leex,*.drab setf eelixir
  autocmd BufNewFile,BufRead Procfile,Brewfile setf ruby
  autocmd BufNewFile,BufRead *.md setf markdown
  autocmd BufNewFile,BufRead mix.lock setf elixir
  autocmd BufNewFile,BufRead *.arb setf eruby
  autocmd BufNewFile,BufRead irbrc,pryrc setf ruby
  autocmd BufNewFile,BufRead * call s:DetectElixir()

  " JSON w/ comments
  autocmd BufNewFile,BufRead *.jsonc setf json
  autocmd FileType json syntax match Comment +\/\/.\+$+

  " Remove trailing whitespace on save
  autocmd BufWritePre * :%s/\s\+$//e

  " Resize panes when window resizes
  autocmd VimResized * :wincmd =
augroup END

filetype on

" install vim-plug if needed.
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/plugged')
  if !exists('g:vscode')
    Plug 'neovim/nvim-lspconfig'
    Plug 'hrsh7th/nvim-compe'

    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'kyazdani42/nvim-web-devicons'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'nvim-treesitter/playground'

    Plug 'norcalli/snippets.nvim'
    Plug 'hrsh7th/vim-vsnip'

    Plug 'norcalli/nvim-colorizer.lua'

    Plug 'windwp/nvim-spectre'

    " Wiki
    Plug 'vimwiki/vimwiki'
    Plug 'itchyny/calendar.vim'
    let g:vimwiki_ext2syntax = {}
    let g:vimwiki_list = [{'path': '~/vimwiki/'}]
    let g:vimwiki_use_calendar = 1

    " <C-n> to select next word with new cursor
    Plug 'mg979/vim-visual-multi'

    " Easier block commenting.
    Plug 'scrooloose/nerdcommenter'
    let g:NERDDefaultAlign = 'left'
    let g:NERDSpaceDelims = 1
    let g:NERDCommentEmptyLines = 1

    Plug 'lewis6991/gitsigns.nvim'      " Git gutter
    Plug 'tpope/vim-fugitive'           " Gblame

    Plug 'simeji/winresizer'            " Resize panes with C-e and hjkl

    " Cosmetic
    Plug 'sonph/onehalf', {'rtp': 'vim/'} " Theme - Light
    Plug 'sainnhe/sonokai'              " Theme - Dark
    Plug 'hoob3rt/lualine.nvim'        " Statusline
  endif

  " Jump to related files, :A, :AS, :AV, and :AT
  Plug 'tpope/vim-projectionist'
  " Plug 'tpope/vim-rails', { 'for': 'ruby' }

  Plug 'numToStr/FTerm.nvim'

  " Add test commands
  Plug 'janko-m/vim-test', { 'on': ['TestNearest', 'TestFile', 'TestSuite', 'TestLast', 'TestVisit'] }

  Plug 'tpope/vim-repeat'             " let . repeat plugin actions too
  Plug 'tpope/vim-surround'           " Add 's' command to give motions context
                                      " eg: `cs"'` will change the surrounding
                                      " double-quotes to single-quotes.

  Plug 'tpope/vim-eunuch'             " Add Bash commands Remove,Move,Find,etc
  Plug 'pbrisbin/vim-mkdir'           " create directories if they don't exist

  if executable('fzf')
    if executable('/usr/local/opt/fzf/bin/fzf')
      Plug '/usr/local/opt/fzf'
      set rtp+=/usr/local/opt/fzf     " Use brew-installed fzf
    endif

    if executable('/usr/bin/fzf')
      set rtp+=/usr/bin/fzf           " Use arch-installed fzf
    endif

    if isdirectory('/usr/share/doc/fzf/examples')
      " Don't use the apt-installed fzf. It's too old
      Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    endif
  endif

  Plug 'junegunn/fzf.vim'           " Fuzzy-finder
  let g:fzf_buffers_jump = 1
  Plug 'ojroques/nvim-lspfuzzy'

  " Plug 'elixir-editors/vim-elixir', {'for': ['eelixir']}
  " Plug 'plasticboy/vim-markdown', {'for': ['markdown']}
  " let g:vim_markdown_conceal = 0
  " let g:vim_markdown_conceal_code_blocks = 0
  " let g:vim_markdown_fenced_languages = ["erb=eruby", "viml=vim", "bash=sh",
  "       \ "ini=dosini", "patch=diff"]
  " let g:vim_markdown_strikethrough = 1
  " let g:vim_markdown_frontmatter = 1
  " let g:vimwiki_global_ext=0
  Plug 'godlygeek/tabular', {'for': ['markdown', 'vimwiki']}

  " Theme for markdown editing
  Plug 'reedes/vim-colors-pencil', {'for': 'markdown' }

  " Soft breaks
  Plug 'reedes/vim-pencil', { 'for': 'markdown' }

  " Focus mode
  Plug 'junegunn/limelight.vim', { 'for': 'markdown' }

  " ProseMode for writing Markdown
  Plug 'junegunn/goyo.vim', { 'for': 'markdown' }

  " Weak language checker
  Plug 'reedes/vim-wordy', { 'for': 'markdown' }
call plug#end()

" Theme
syntax on
