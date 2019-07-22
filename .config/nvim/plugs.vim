map K <Nop>

let g:elixirls = {
  \ 'path': printf('%s/%s', stdpath('config'), 'bundle/elixir-ls'),
  \ }

let g:elixirls.lsp = printf(
  \ '%s/%s',
  \ g:elixirls.path,
  \ 'release/language_server.sh')

function! g:elixirls.compile(...)
  let l:commands = join([
    \ 'mix local.hex --force',
    \ 'mix local.rebar --force',
    \ 'mix deps.get',
    \ 'mix compile',
    \ 'mix elixir_ls.release'
    \ ], '&&')

  echom '>>> Compiling elixirls'
  silent call system(l:commands)
  echom '>>> elixirls compiled'
endfunction

" install vim-plug if needed.
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Configure Language Servers
let g:lang_server = {
  \ 'elixir': printf('%s/%s', stdpath('config'), 'plugged/elixir-ls'),
  \ }

let g:lang_server.elixir_lsp = printf('%s/%s', g:lang_server.elixir, 'release/language_server.sh')

function! g:lang_server.compile_elixir(...)
  let l:commands = join([
    \ 'mix local.hex --force',
    \ 'mix local.rebar --force',
    \ 'mix deps.get',
    \ 'mix compile',
    \ 'mix elixir_ls.release'
    \ ], '&&')

  echom '>>> Compiling elixirls'
  silent call system(l:commands)
  echom '>>> elixirls compiled'
endfunction

call plug#begin('~/.config/nvim/plugged')
  Plug 'ludovicchabant/vim-gutentags' " Ctags support.

  " Language server support
  Plug 'JakeBecker/elixir-ls', { 'do': { -> g:elixirls.compile() } }

  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'neoclide/coc-yaml', {'do': 'yarn install --frozen-lockfile'}
  Plug 'neoclide/coc-json', {'do': 'yarn install --frozen-lockfile'}
  Plug 'neoclide/coc-css', {'do': 'yarn install --frozen-lockfile'}
  Plug 'neoclide/coc-solargraph', {'do': 'yarn install --frozen-lockfile'}
  Plug 'amiralies/coc-elixir', {'do': 'yarn install --frozen-lockfile'}
  Plug 'neoclide/coc-tsserver', {'do': 'yarn install --frozen-lockfile'}

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

  " Language servers
  Plug 'JakeBecker/elixir-ls', { 'do': { -> g:lang_server.compile_elixir() } }
  Plug 'mads-hartmann/bash-language-server', { 'do': 'yarn global install --frozen-lockfile && asdf reshim nodejs'}
  Plug 'iamcco/coc-diagnostic', {'do': 'yarn global install --frozen-lockfile && asdf reshim nodejs'}

  " Language server integration
  Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
  Plug 'neoclide/coc-sources', {'do': 'yarn install --frozen-lockfile'}
  Plug 'neoclide/coc-yaml', {'do': 'yarn install --frozen-lockfile'}
  Plug 'neoclide/coc-json', {'do': 'yarn install --frozen-lockfile'}
  Plug 'neoclide/coc-css', {'do': 'yarn install --frozen-lockfile'}
  Plug 'neoclide/coc-solargraph', {'do': 'yarn install --frozen-lockfile'}
  Plug 'amiralies/coc-elixir', {'do': 'yarn install --frozen-lockfile'}
  Plug 'neoclide/coc-tsserver', {'do': 'yarn install --frozen-lockfile'}
  Plug 'neoclide/coc-eslint', {'do': 'yarn install --frozen-lockfile'}
  Plug 'neoclide/coc-prettier', {'do': 'yarn install --frozen-lockfile'}

  " :Dash
  if has('mac')
    Plug 'rizzatti/dash.vim', { 'on': 'Dash' }
  endif

  " Wiki
  let g:vimwiki_list = [{'path': '~/Dropbox/vimwiki/',
                      \ 'syntax': 'markdown', 'ext': '.md'}]
  let g:vimwiki_use_calendar = 1
  Plug 'vimwiki/vimwiki'
  Plug 'itchyny/calendar.vim'

  " Jump to related files, :A, :AS, :AV, and :AT
  Plug 'tpope/vim-projectionist'
  Plug 'andyl/vim-projectionist-elixir', { 'for': 'elixir' }
  Plug 'tpope/vim-rails', { 'for': 'ruby' }

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

  Plug 'tpope/vim-repeat'             " let . repeat plugin actions too
  Plug 'tpope/vim-endwise'            " Auto-close if, do, def
  Plug 'tpope/vim-surround'           " Add 's' command to give motions context
                                      " eg: `cs"'` will change the surrounding
                                      " double-quotes to single-quotes.

  Plug 'tpope/vim-eunuch'             " Add Bash commands Remove,Move,Find,etc
  Plug 'pbrisbin/vim-mkdir'           " create directories if they don't exist

  Plug 'simeji/winresizer'            " Resize panes with C-e and hjkl

  " FZF and RipGrep
  if isdirectory('/home/linuxbrew/.linuxbrew/opt/fzf')
    Plug '/home/linuxbrew/.linuxbrew/opt/fzf' " Use brew-installed fzf
  endif

  if isdirectory('/usr/local/opt/fzf')
    Plug '/usr/local/opt/fzf'         " Use brew-installed fzf
  endif
  Plug 'junegunn/fzf.vim'             " Fuzzy-finder

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

call coc#config('languageserver', {
\  'elixir': {
\    'command': g:lang_server.elixir_lsp,
\    'trace.server': 'verbose',
\    'filetypes': ['elixir', 'eelixir'],
\    'settings': {
\      'dialyzerEnabled': 'false'
\    }
\  }
\})
