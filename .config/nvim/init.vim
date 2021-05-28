" General
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

" Netrw, make it more like a project drawer
let g:netrw_preview   = 1
let g:netrw_liststyle = 3
let g:netrw_winsize   = 30
let g:netrw_banner = 0

" More bash-like command complete selection
cnoremap <Left> <Space><BS><Left>
cnoremap <Right> <Space><BS><Right>

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
nmap gco :GBranches<CR>

" Turn on rendering whitespace
set listchars+=trail:·,precedes:←,extends:→,tab:¬\ ,nbsp:+,conceal:※
set list

" Turn on undo file so I can undo even after closing a file
silent !mkdir -p ~/.cache/nvim/undo > /dev/null 2>&1

set undofile
set undodir=~/.cache/nvim/undo

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
  if $TERM_PROGRAM == "iTerm.app" || $TERMINFO =~ "kitty\.app" || $TERMINFO =~ "kitty/terminfo" || $KITTY_WINDOW_ID != ""
    return 1
  else
    return 0
  endif
endfunction

if ModernTerminal()
  " Turn on 24bit color
  set termguicolors

  " https://sw.kovidgoyal.net/kitty/faq.html#using-a-color-theme-with-a-background-color-does-not-work-well-in-vim
  let &t_ut=''

  " https://github.com/vim/vim/issues/993#issuecomment-255651605
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
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

" Change Tabs
nnoremap <silent> <c-left> :tabprevious<CR>
nnoremap <silent> <silent> <c-right> :tabnext<CR>

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

" Set lines and number gutter
set cursorline " turn on row highlighting where cursor is
set ruler      " turn on ruler information in statusline

" Set number gutter
set number

" Switch between the last two files
nnoremap <leader><leader> <c-^>

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
set completeopt=menuone,noinsert,noselect
set shortmess+=c

function! s:show_documentation()
  if (index(['vim', 'help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  endif
endfunction

nmap <silent> gd :call <sid>show_documentation()<cr>

nmap <leader>/ <leader>c<space>
vmap <leader>/ <leader>c<space>

if filereadable(expand("~/.config/nvim/plugs.vim"))
  source ~/.config/nvim/plugs.vim
endif

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


if executable('rg')
  set grepprg="rg --vimgrep"   " use ripgrep
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

nnoremap <leader>cal :Calendar -view=year -split=horizontal -position=bottom -height=12<cr>

" Theme
syntax on
set redrawtime=10000

function! LightMode()
  let g:indentLine_color_gui = '#EAEAEA'
  set background=light
  colorscheme onehalflight
  let g:lightline.colorscheme='onehalflight'

  if ModernTerminal()
    " Comments should be italics
    hi Comment gui=italic
  endif
endfunction

nmap <leader>lm :call LightMode()<cr>

function! DarkMode()
  let g:indentLine_color_gui = '#373737'
  set background=dark
  colorscheme sonokai
  let g:lightline.colorscheme='sonokai'

  " Transparent Backgrounds
  if ModernTerminal()
    " Comments should be italics
    hi Comment gui=italic
  endif
endfunction
nmap <leader>dm :call DarkMode()<cr>

if filereadable(expand("~/.config/nvim/terminal.vim"))
  source ~/.config/nvim/terminal.vim
endif

:call DarkMode()

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
  autocmd BufNewFile,BufRead irbrc,pryrc setf ruby

  autocmd BufEnter * lua require('completion').on_attach()
  " autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()
  " autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
  " autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()

  " JSON w/ comments
  autocmd BufNewFile,BufRead *.jsonc setf json
  autocmd FileType json syntax match Comment +\/\/.\+$+

  " Remove trailing whitespace on save
  autocmd BufWritePre * :%s/\s\+$//e

  " Resize panes when window resizes
  autocmd VimResized * :wincmd =
augroup END

augroup netrwEx
  " Turn off line numbers in file tree
  autocmd FileType netrw setlocal nonumber norelativenumber
  autocmd FileType netrw setlocal colorcolumn=
augroup END

filetype on

:lua << LUA
  local a = vim.api
  local lspconfig = require('lspconfig')

  local lsp_servers = {
    bashls = {},
    cssls = {
      root_dir = lspconfig.util.root_pattern("package.json", ".git")
    },
    dockerls = {},
    elixirls = {
      cmd = { vim.loop.os_homedir().."/.cache/elixir-ls/release/language_server.sh" };
      settings = {
        elixirLS = {
          dialyzerFormat = "dialyxir_short";
        }
      };
    },
    html = {},
    jsonls = {},
    solargraph = {},
    sqlls = {
      cmd = {"sql-language-server", "up", "--method", "stdio"};
    },
    tsserver = {},
    vimls = {},
    vuels = {},
    yamlls = {},
  }

  local function make_on_attach(config)
    return function(client)
      print('LSP Starting')

      require('completion').on_attach(client)

      local opts = { noremap = true, silent = true }
      a.nvim_buf_set_keymap(0, 'n', 'K',  '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
      a.nvim_buf_set_keymap(0, 'n', '<c-space>', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
      a.nvim_buf_set_keymap(0, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
      a.nvim_buf_set_keymap(0, 'n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
      a.nvim_buf_set_keymap(0, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
      a.nvim_buf_set_keymap(0, 'n', '<leader>gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
      a.nvim_buf_set_keymap(0, 'n', '<leader>gs', '<cmd>lua vim.lsp.buf.document_symbol()<cr>', opts)
      a.nvim_buf_set_keymap(0, 'n', '<leader>gw', '<cmd>lua vim.lsp.buf.workspace_symbol()<cr>', opts)
      a.nvim_buf_set_keymap(0, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
      a.nvim_buf_set_keymap(0, 'n', '<leader>gi', '<cmd>lua vim.lsp.buf.incoming_calls()<cr>', opts)
      a.nvim_buf_set_keymap(0, 'n', '<leader>go', '<cmd>lua vim.lsp.buf.outgoing_calls()<cr>', opts)
      a.nvim_buf_set_keymap(0, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)

      if client.resolved_capabilities.document_highlight == true then
        a.nvim_command('augroup lsp_aucmds')
        a.nvim_command('au CursorHold <buffer> lua vim.lsp.buf.document_highlight()')
        a.nvim_command('au CursorMoved <buffer> lua vim.lsp.buf.clear_references()')
        a.nvim_command('augroup END')
      end

      a.nvim_command('setlocal omnifunc=v:lua.vim.lsp.omnifunc')
    end
  end

  for lsp_server, config in pairs(lsp_servers) do
    config.on_attach = make_on_attach(config)
    local setup = lspconfig[lsp_server]
    lspconfig[lsp_server].setup(config)
  end

  require('lspfuzzy').setup({})

  require('spectre').setup()

  require('colorizer').setup({
    'css',
    'javascript',
    'html',
    'lua',
    'vim',
    'eelixir',
    'erb'
  })
LUA

command! -nargs=0 Format :lua vim.lsp.buf.formatting()

command! -nargs=? LspActiveClients lua print(vim.inspect(vim.lsp.get_active_clients()))
command! -nargs=? LspLog lua vim.api.nvim_command("split "..vim.lsp.get_log_path())

" doesn't work
" command! -nargs=1 SqlSwitch call luaeval('vim.lsp.buf.execute_command(_A)', <f-args>)

function! RestartLsp()
  lua vim.lsp.stop_client(vim.lsp.get_active_clients())
  edit
endfunction

command! -nargs=? LspRestart :call RestartLsp()

sign define LspDiagnosticsSignError text=⨯ texthl=LspDiagnosticsSignError linehl= numhl=
sign define LspDiagnosticsSignWarning text=⚠ texthl=LspDiagnosticsSignWarning linehl= numhl=
sign define LspDiagnosticsSignInformation text= texthl=LspDiagnosticsSignInformation linehl= numhl=
sign define LspDiagnosticsSignHint text= texthl=LspDiagnosticsSignHint linehl= numhl=
