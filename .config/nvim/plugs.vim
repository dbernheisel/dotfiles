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

    Plug 'justinmk/vim-dirvish'

    Plug 'norcalli/nvim-colorizer.lua'

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

    " <C-n> to select next word with new cursor
    Plug 'mg979/vim-visual-multi'

    " Easier block commenting.
    Plug 'scrooloose/nerdcommenter'
    let g:NERDDefaultAlign = 'left'
    let g:NERDSpaceDelims = 1
    let g:NERDCommentEmptyLines = 1


    Plug 'airblade/vim-gitgutter'       " Git gutter
    Plug 'tpope/vim-fugitive'           " Gblame
    Plug 'rhysd/git-messenger.vim'      " GitMessenger floating window
    let g:git_messenger_include_diff = "current"
    nmap <Leader>gb <Plug>(git-messenger)

    Plug 'simeji/winresizer'            " Resize panes with C-e and hjkl

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
  endif

  " Jump to related files, :A, :AS, :AV, and :AT
  Plug 'tpope/vim-projectionist'
  Plug 'andyl/vim-projectionist-elixir', { 'for': 'elixir' }
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

  Plug 'elixir-editors/vim-elixir', {'for': ['elixir', 'eelixir']}
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

"" Dirvish

nmap <silent> - :<C-U>call <SID>dirvish_toggle()<CR>
nmap <silent> <leader>b :call <SID>dirvish_toggle()<CR>

function! s:dirvish_open(cmd, bg) abort
  let path = getline('.')
  if isdirectory(path)
    if a:cmd ==# 'edit' && a:bg ==# '0'
      call dirvish#open(a:cmd, 0)
    endif
  else
    if a:bg
      call dirvish#open(a:cmd, 1)
    else
      bwipeout
      execute a:cmd ' ' path
    endif
  endif
endfunction

function! s:dirvish_toggle() abort
  let height = float2nr(&lines)
  let width  = float2nr(&columns * 0.34)
  let top    = float2nr(width - &columns)
  let vertical = 1
  let opts   = {'relative': 'editor', 'row': vertical, 'col': top, 'width': width, 'height': height, 'style': 'minimal' }
  let fdir = expand('%:h')
  let path = expand('%:p')
  call nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
  if fdir ==# ''
    let fdir = '.'
  endif

  call dirvish#open(fdir)

  if !empty(path)
    call search('\V\^'.escape(path, '\').'\$', 'cw')
  endif
endfunction

augroup vimrc
    autocmd FileType dirvish nmap <silent> <buffer> <CR>  :<C-U>call <SID>dirvish_open('edit'   , 0)<CR>
    autocmd FileType dirvish nmap <silent> <buffer> v     :<C-U>call <SID>dirvish_open('vsplit' , 0)<CR>
    autocmd FileType dirvish nmap <silent> <buffer> V     :<C-U>call <SID>dirvish_open('vsplit' , 1)<CR>
    autocmd FileType dirvish nmap <silent> <buffer> x     :<C-U>call <SID>dirvish_open('split'  , 0)<CR>
    autocmd FileType dirvish nmap <silent> <buffer> X     :<C-U>call <SID>dirvish_open('split'  , 1)<CR>
    autocmd FileType dirvish nmap <silent> <buffer> t     :<C-U>call <SID>dirvish_open('tabedit', 0)<CR>
    autocmd FileType dirvish nmap <silent> <buffer> T     :<C-U>call <SID>dirvish_open('tabedit', 1)<CR>
    autocmd FileType dirvish nmap <silent> <buffer> -     <Plug>(dirvish_up)
    autocmd FileType dirvish nmap <silent> <buffer> <ESC> :bd<CR>
    autocmd FileType dirvish nmap <silent> <buffer> q     :bd<CR>
augroup END

" Dirvish replace netrw

let g:loaded_netrwPlugin = 1
command! -nargs=? -complete=dir Explore Dirvish <args>
command! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args>
command! -nargs=? -complete=dir Vexplore leftabove vsplit | silent Dirvish <args>
command! -nargs=? -complete=dir Lexplore leftabove vsplit | silent Dirvish <args>
