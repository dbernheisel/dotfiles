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

" Use the floating windows for FZF
if exists("*nvim_open_win")
  let g:fzf_layout = { 'window': 'call FloatingFZF()' }

  function! FloatingFZF()
    let buf = nvim_create_buf(v:false, v:true)

    let height = &lines - 3
    let width = float2nr(&columns - (&columns * 2 / 20))
    let col = float2nr((&columns - width) / 2)

    let opts = {
          \ 'relative': 'editor',
          \ 'row': 1,
          \ 'col': col,
          \ 'width': width,
          \ 'height': height
          \ }

    call nvim_open_win(buf, v:true, opts)
  endfunction
endif

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

  " Language server integration
  "
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  let g:coc_global_extensions = ['coc-emoji', 'coc-highlight', 'coc-eslint',
        \ 'coc-prettier', 'coc-yaml', 'coc-json', 'coc-css', 'coc-solargraph',
        \ 'coc-elixir', 'coc-tsserver', 'coc-diagnostic']

  " :Dash
  if has('mac')
    Plug 'rizzatti/dash.vim', { 'on': 'Dash' }
  endif

  " Wiki
  let g:vimwiki_list = [{'path': '~/Dropbox/vimwiki/', 'syntax': 'markdown'}]
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
  let NERDTreeShowLineNumbers = 0

  " Easier block commenting.
  Plug 'scrooloose/nerdcommenter'
  let g:NERDDefaultAlign = 'left'
  let g:NERDSpaceDelims = 1
  let g:NERDCommentEmptyLines = 1

  " Add test commands
  Plug 'janko-m/vim-test', { 'on': ['TestNearest', 'TestFile', 'TestSuite', 'TestLast', 'TestVisit'] }
  let g:test#strategy = "neoterm"
  let g:neoterm_shell = '$SHELL -l'
  let g:neoterm_default_mod = 'vert'
  let g:neoterm_size = 80
  let g:neoterm_fixedsize = 1
  let g:neoterm_keep_term_open = 0
  let test#ruby#rspec#options = {
    \ 'nearest': '--backtrace',
    \ 'suite':   '--profile 5',
  \}

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
  Plug 'sonph/onehalf', {'rtp': 'vim/'} " Theme - Light
  Plug 'Erichain/vim-monokai-pro'     " Theme - Dark
  Plug 'reewr/vim-monokai-phoenix'    " Theme - Darker
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
    \     [ 'cocstatus', 'gitbranch' ]
    \   ]
    \ },
    \ 'component_function': {
    \   'cocstatus': 'coc#status',
    \   'fileformat': 'LightlineFileformat',
    \   'filetype': 'LightlineFiletype',
    \   'fileencoding': 'LightlineFileencoding',
    \   'gitbranch': 'fugitive#head'
    \   }
    \ }


  Plug 'elixir-editors/vim-elixir', {'for': ['elixir', 'eelixir']}

  Plug 'plasticboy/vim-markdown', {'for': ['markdown', 'vimwiki']}
  Plug 'godlygeek/tabular', {'for': ['markdown', 'vimwiki']}
  let g:vim_markdown_fenced_languages = ["erb=eruby", "viml=vim", "bash=sh", "ini=dosini"]
  let g:vim_markdown_strikethrough = 1
  let g:vim_markdown_frontmatter = 1

  " Syntax highlighting
  let g:polyglot_disabled = ['markdown', 'elixir', 'eelixir']
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
