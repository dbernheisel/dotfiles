" ln -s ~/dotfiles/vim/plugs.vim ~/.config/nvim/plugs.vim
map K <Nop>

" install vim-plug if needed.
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/plugged')
  " Language server support
  "Plug 'autozimu/LanguageClient-neovim', {
    "\ 'branch': 'next',
    "\ 'do': 'bash install.sh',
    "\ }

  "Plug 'prabirshrestha/async.vim'
  "Plug 'prabirshrestha/vim-lsp'

  " Linters
  Plug 'w0rp/ale'

  " Autocomplete
  let g:deoplete#enable_at_startup = 1
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

  " :Dash
  if has('mac')
    Plug 'rizzatti/dash.vim', { 'on': 'Dash' }
  endif

  " Wiki
  let g:vimwiki_list = [{'path': '~/Dropbox/vimwiki/',
                      \ 'syntax': 'markdown', 'ext': '.md'}]
  Plug 'vimwiki/vimwiki'
  Plug 'itchyny/calendar.vim'
  nnoremap <leader>cc :Calendar -view=year -split=horizontal -position=bottom -height=12<cr>

  " Jump to related files, :A, :AS, :AV, and :AT
  Plug 'tpope/vim-projectionist'
  Plug 'andyl/vim-projectionist-elixir', { 'for': 'elixir' }
  Plug 'tpope/vim-rails', { 'for': 'ruby' }

  " Elixir formatting
  Plug 'mhinz/vim-mix-format', { 'for': 'elixir' }

  " <C-n> to select next word with new cursor
  Plug 'terryma/vim-multiple-cursors'

  " Sidebar file explorer
  Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

  " Easier block commenting.
  Plug 'scrooloose/nerdcommenter'

  " Add :Gist commands
  Plug 'mattn/webapi-vim'
  Plug 'mattn/gist-vim'

  " Add test commands
  Plug 'janko-m/vim-test', { 'on': ['TestNearest', 'TestFile', 'TestSuite', 'TestLast', 'TestVisit'] }

  Plug 'kassio/neoterm'

  Plug 'airblade/vim-gitgutter'       " Git gutter
  Plug 'tpope/vim-fugitive'           " Gblame

  Plug 'dkprice/vim-easygrep'         " Grep across files
  Plug 'tpope/vim-endwise'            " Auto-close if, do, def
  Plug 'tpope/vim-surround'           " Add 's' command to give motions context
                                      " eg: `cs"'` will change the surrounding
                                      " double-quotes to single-quotes.

  Plug 'tpope/vim-eunuch'             " Add Bash commands Remove,Move,Find,etc
  Plug 'pbrisbin/vim-mkdir'           " create directories if they don't exist

  Plug 'simeji/winresizer'            " Resize panes with C-e and hjkl

  Plug 'ludovicchabant/vim-gutentags' " Ctags support.

  " FZF and RipGrep
  if isdirectory('/home/linuxbrew/.linuxbrew/opt/fzf')
    Plug '/home/linuxbrew/.linuxbrew/opt/fzf' " Use brew-installed fzf
  endif

  if isdirectory('/usr/local/opt/fzf')
    Plug '/usr/local/opt/fzf'         " Use brew-installed fzf
  endif
  Plug 'junegunn/fzf.vim'             " Fuzzy-finder
  Plug 'zackhsi/fzf-tags'             " fzf for tags
  nmap <C-]> <Plug>(fzf_tags)

  " Cosmetic
  Plug 'ryanoasis/vim-devicons'       " :)
  Plug 'crater2150/vim-theme-chroma'  " Theme - Light
  Plug 'Erichain/vim-monokai-pro'     " Theme - Dark
  Plug 'reewr/vim-monokai-phoenix'    " Theme - Darker
  Plug 'itchyny/lightline.vim'        " Statusline

  " Syntax highlighting
  Plug 'sheerun/vim-polyglot'         " Languages support.

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
