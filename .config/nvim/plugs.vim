map K <Nop>

" install vim-plug if needed.
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/plugged')
  if !exists('g:vscode')
    Plug 'neovim/nvim-lspconfig'
    Plug 'nvim-lua/completion-nvim'

    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'kyazdani42/nvim-web-devicons'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'nvim-treesitter/playground'

    Plug 'norcalli/nvim-colorizer.lua'

    Plug 'windwp/nvim-spectre'

    " Wiki
    let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown'}]
    let g:vimwiki_use_calendar = 1
    Plug 'vimwiki/vimwiki'
    Plug 'itchyny/calendar.vim'

    " <C-n> to select next word with new cursor
    Plug 'mg979/vim-visual-multi'

    " Easier block commenting.
    Plug 'scrooloose/nerdcommenter'
    let g:NERDDefaultAlign = 'left'
    let g:NERDSpaceDelims = 1
    let g:NERDCommentEmptyLines = 1


    Plug 'airblade/vim-gitgutter'       " Git gutter
    Plug 'tpope/vim-fugitive'           " Gblame

    Plug 'simeji/winresizer'            " Resize panes with C-e and hjkl

    " Cosmetic
    Plug 'sonph/onehalf', {'rtp': 'vim/'} " Theme - Light
    " Plug 'reewr/vim-monokai-phoenix'    " Theme - Dark
    " Plug 'bluz71/vim-moonfly-colors'    " Theme - Dark
    Plug 'sainnhe/sonokai'              " Theme - Dark
    let g:sonokai_transparent_background = 1
    Plug 'itchyny/lightline.vim'        " Statusline
    let g:lightline = {
      \ 'active': {
      \   'left':  [
      \     [ 'mode', 'paste' ],
      \     [ 'readonly', 'filename', 'modified' ]
      \   ],
      \   'right': [
      \     [ 'lineinfo' ],
      \     [ 'filetype', 'fileformat', 'fileencoding' ],
      \     [ 'gitbranch' ]
      \   ]
      \ },
      \ 'component_function': {
      \   'fileformat': 'LightlineFileformat',
      \   'filetype': 'LightlineFiletype',
      \   'fileencoding': 'LightlineFileencoding',
      \   'gitbranch': 'fugitive#head'
      \   }
      \ }
  endif

  " Jump to related files, :A, :AS, :AV, and :AT
  Plug 'tpope/vim-projectionist'
  Plug 'tpope/vim-rails', { 'for': 'ruby' }

  Plug 'kassio/neoterm'

  " Add test commands
  Plug 'janko-m/vim-test', { 'on': ['TestNearest', 'TestFile', 'TestSuite', 'TestLast', 'TestVisit'] }
  let g:test#strategy = "neoterm"
  let g:neoterm_shell = '$SHELL -l'
  let g:neoterm_default_mod = 'vert'
  let g:neoterm_size = 80
  let g:neoterm_fixedsize = 1
  let g:neoterm_keep_term_open = 0
  let g:neoterm_term_per_tab = 1
  let test#ruby#rspec#options = {
        \ 'nearest': '--backtrace',
        \ 'suite':   '--profile 5',
        \ }
  let test#shell#bats#options = {
        \ 'nearest': '-t'
        \ }

  Plug 'tpope/vim-repeat'             " let . repeat plugin actions too
  Plug 'tpope/vim-endwise'            " Auto-close if, do, def
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
  Plug 'stsewd/fzf-checkout.vim'
  Plug 'ojroques/nvim-lspfuzzy'

  Plug 'elixir-editors/vim-elixir', {'for': ['eelixir']}
  Plug 'plasticboy/vim-markdown', {'for': ['markdown']}
  let g:vim_markdown_conceal = 0
  let g:vim_markdown_conceal_code_blocks = 0
  let g:vim_markdown_fenced_languages = ["erb=eruby", "viml=vim", "bash=sh",
        \ "ini=dosini", "patch=diff"]
  let g:vim_markdown_strikethrough = 1
  let g:vim_markdown_frontmatter = 1
  let g:vimwiki_global_ext=0
  Plug 'godlygeek/tabular', {'for': ['markdown', 'vimwiki']}

  " Syntax highlighting
  let g:polyglot_disabled = ['ruby', 'markdown', 'elixir', 'eelixir']
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
