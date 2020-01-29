map K <Nop>

" Use the floating windows for FZF
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

  function! FloatingDrawer()
    let height = float2nr(&lines)
    let width = float2nr(&columns * 0.25)
    let horizontal = float2nr(width - &columns)
    let vertical = 1

    let opts = {
          \ 'relative': 'editor',
          \ 'row': vertical,
          \ 'col': horizontal,
          \ 'width': width,
          \ 'style': 'minimal',
          \ 'height': height
          \ }

    let buf = nvim_create_buf(v:false, v:true)
    let win = nvim_open_win(buf, v:true, opts)
    call setwinvar(win, '&winhl', 'NormalFloat:TabLine')
  endfunction

endif

let g:fzf_postprocess=' | sort -V'
if executable('devicon-lookup')
  let g:fzf_postprocess=' | sort -V | devicon-lookup'

  function! s:line_handler(lines)
    if len(a:lines) < 2
      return
    endif
    normal! m'
    echom a:lines

    let cmd = s:action_for(a:lines[0])
    echom cmd
    if !empty(cmd) && stridx('edit', cmd) < 0
      execute 'silent' cmd
    endif

    let keys = split(a:lines[1], '\t')
    execute 'buffer' keys[0]
    execute keys[2]
    normal! ^zvzz
  endfunction

  function! FZFWithDevIcons()
    function! s:edit_file(items)
      let items = a:items
      let i = 1
      let ln = len(items)
      while i < ln
        let item = items[i]
        let parts = split(item, ' ')
        let file_path = get(parts, 1, '')
        let items[i] = file_path
        let i += 1
      endwhile
      call s:Sink(items)
    endfunction

    let opts = fzf#wrap({})
    let opts.source = $FZF_DEFAULT_COMMAND . g:fzf_postprocess
    let s:Sink = opts['sink*']
    let opts['sink*'] = function('s:edit_file')
    call fzf#run(opts)
  endfunction

  command! Files call FZFWithDevIcons()<CR>
endif

command! Drawer call fzf#run(fzf#wrap({
      \ 'source': $FZF_DEFAULT_COMMAND . g:fzf_postprocess,
      \ 'options': ['--layout=reverse', '--tiebreak=end,length'],
      \ 'window': 'call FloatingDrawer()'
      \ }))

" install vim-plug if needed.
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

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
  Plug 'elixir-lsp/elixir-ls'

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
    Plug '/usr/local/opt/fzf'         " Use arch-installed fzf
  endif

  if isdirectory('/usr/share/doc/fzf/examples')
    Plug '/usr/share/doc/fzf/examples' " Use apt-installed fzf
  endif
  Plug 'junegunn/fzf.vim'             " Fuzzy-finder
  let g:fzf_buffers_jump = 1

  " Cosmetic
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
