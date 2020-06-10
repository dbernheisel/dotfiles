map K <Nop>

" install vim-plug if needed.
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/plugged')
  " Plug 'ludovicchabant/vim-gutentags' " Ctags support.

  " Language servers
  Plug 'elixir-lsp/elixir-ls', { 'do': { -> g:ElixirLS.compile() } }

  " Language server integration
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  let g:coc_global_extensions = ['coc-emoji', 'coc-highlight', 'coc-eslint',
        \ 'coc-prettier', 'coc-yaml', 'coc-json', 'coc-css', 'coc-solargraph',
        \ 'coc-elixir', 'coc-tailwindcss', 'coc-tsserver', 'coc-diagnostic']

  Plug 'justinmk/vim-dirvish'

  " :Dash
  if has('mac')
    Plug 'rizzatti/dash.vim', { 'on': 'Dash' }
  endif

  " Indent line guides... wish I didn't need this.
  Plug 'Yggdroot/indentLine'
  let g:indentLine_char_list = ['|']
  let g:indentLine_faster = 1
  let g:indentLine_bufTypeExclude = ['help', 'terminal']

  " Wiki
  let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown'}]
  let g:vimwiki_use_calendar = 1
  Plug 'vimwiki/vimwiki'
  Plug 'itchyny/calendar.vim'

  " Jump to related files, :A, :AS, :AV, and :AT
  Plug 'tpope/vim-projectionist'
  Plug 'andyl/vim-projectionist-elixir', { 'for': 'elixir' }
  Plug 'tpope/vim-rails', { 'for': 'ruby' }

  " <C-n> to select next word with new cursor
  Plug 'mg979/vim-visual-multi'

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
        \ }
  let test#shell#bats#options = {
        \ 'nearest': '-t'
        \ }

  Plug 'conweller/findr.vim'
  let g:findr_floating_window = {
        \ 'window': 'FindrFloatingWindow()'
        \ }

  let g:findr_border = {
        \   'top':    ['─', '─', '┐'],
        \   'middle': [' ', ' ', '│'],
        \   'bottom': ['─', '─', '┘'],
        \ }

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


  if executable('fzf')
    if executable('/usr/local/opt/fzf')
      set rtp+=/usr/local/opt/fzf
      Plug '/usr/local/opt/fzf'         " Use arch-installed fzf
    endif

    if executable('/usr/bin/fzf')
      set rtp+=/usr/bin/fzf
    endif

    if isdirectory('/usr/share/doc/fzf/examples')
      Plug '/usr/share/doc/fzf/examples' " Use apt-installed fzf
    endif

    Plug 'junegunn/fzf.vim'             " Fuzzy-finder
    let g:fzf_buffers_jump = 1
  endif

  Plug 'liuchengxu/vista.vim'

  " Cosmetic
  Plug 'sonph/onehalf', {'rtp': 'vim/'} " Theme - Light
  Plug 'reewr/vim-monokai-phoenix'    " Theme - Dark
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


  Plug 'elixir-editors/vim-elixir', {'for': ['elixir', 'eelixir']}

  Plug 'plasticboy/vim-markdown', {'for': ['markdown', 'vimwiki']}
  let g:vim_markdown_conceal = 0
  let g:vim_markdown_conceal_code_blocks = 0
  Plug 'godlygeek/tabular', {'for': ['markdown', 'vimwiki']}
  let g:vim_markdown_fenced_languages = ["erb=eruby", "viml=vim", "bash=sh",
        \ "ini=dosini", "patch=diff"]
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

"========= FZF ===========

let g:fzf_postprocess = ''
let g:fzf_spec = {}

if exists("*nvim_open_win")
  function! FloatingFZF()
    let height = &lines - 3
    let width = float2nr(&columns - (&columns * 2 / 20))
    let col = float2nr((&columns - width) / 2)

    let opts = {
          \ 'relative': 'editor',
          \ 'row': 1,
          \ 'col': col,
          \ 'width': width,
          \ 'style': 'minimal',
          \ 'height': height
          \ }

    let buf = nvim_create_buf(v:false, v:true)
    let win = nvim_open_win(buf, v:true, opts)
    call setwinvar(win, '&winhl', 'NormalFloat:TabLine')
  endfunction

  let g:fzf_layout = { 'window': 'call FloatingFZF()' }
endif

let g:use_devicon = 0
if executable('devicon-lookup')
  let g:use_devicon = 1
  let g:fzf_postprocess = g:fzf_postprocess.' | devicon-lookup'
endif

let g:fzf_spec.source = $FZF_DEFAULT_COMMAND . g:fzf_postprocess

function! DevIconToVim(item)
  if g:use_devicon
    return get(split(a:item, ' '), 1, '')
  else
    return a:item
  endif
endfunction

function! FzfEditFile(lines)
  let action = a:lines[0]
  let lines = map(a:lines[1:], 'DevIconToVim(v:val)')
  call s:fzf_sink([action] + lines)
endfunction

function! FZFFiles()
  let opts = fzf#wrap({})
  let s:fzf_sink = opts['sink*']
  let opts = extend(opts, g:fzf_spec)
  let opts['sink*'] = function('FzfEditFile')
  call fzf#run(opts)
endfunction

command! Files call FZFFiles()

"" COC

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

"" Findr

function! FindrFloatingWindow()
  return {
        \ 'relative': 'editor',
        \ 'row': 0,
        \ 'col': 0,
        \ 'height': &lines - 2,
        \ 'style': 'minimal',
        \ 'width': float2nr(&columns / 3)
        \ }
endfunction

"" ELixirLS

let g:ElixirLS = {}
let ElixirLS.path = printf('%s/%s', stdpath('config'), 'plugged/elixir-ls')
let ElixirLS.lsp = printf('%s/%s', ElixirLS.path, 'release/language_server.sh')
let ElixirLS.cmd = join([
        \ 'asdf install &&',
        \ 'mix do',
        \ 'local.hex --force --if-missing,',
        \ 'local.rebar --force,',
        \ 'deps.get,',
        \ 'compile,',
        \ 'elixir_ls.release'
        \ ], ' ')

function ElixirLS.on_stdout(_job_id, data, _event)
  let self.output[-1] .= a:data[0]
  call extend(self.output, a:data[1:])
endfunction

let ElixirLS.on_stderr = function(ElixirLS.on_stdout)

function ElixirLS.on_exit(_job_id, exitcode, _event)
  if a:exitcode[0] == 0
    echom '>>> ElixirLS compiled'
  else
    echoerr join(self.output, ' ')
    echoerr '>>> ElixirLS compilation failed'
  endif
endfunction

function ElixirLS.compile()
  let me = copy(g:ElixirLS)
  echom '>>> compiling ElixirLS'
  let me.output = ['']
  let me.id = jobstart('cd ' . me.path . ' && git pull && ' . me.cmd, me)
endfunction

call coc#config('elixir', {
  \ 'command': g:ElixirLS.lsp,
  \ 'filetypes': ['eelixir', 'elixir']
  \})
call coc#config('elixir.pathToElixirLS', g:ElixirLS.lsp)

"" Dirvish

let g:loaded_netrwPlugin = 1
command! -nargs=? -complete=dir Explore Dirvish <args>
command! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args>
command! -nargs=? -complete=dir Vexplore leftabove vsplit | silent Dirvish <args>
command! -nargs=? -complete=dir Lexplore leftabove vsplit | silent Dirvish <args>
