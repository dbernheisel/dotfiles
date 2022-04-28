local U = require("dbern.utils")

vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

vim.opt.title = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.showmode = false
vim.opt.showcmd = true
vim.opt.encoding = 'utf-8'
vim.opt.completeopt = { 'menuone', 'noselect' }

if U.is_modern_terminal() then
  -- Turn on 24bit color
  vim.opt.termguicolors = true
  vim.cmd [[
    " https://sw.kovidgoyal.net/kitty/faq.html#using-a-color-theme-with-a-background-color-does-not-work-well-in-vim
    let &t_ut=''

    " https://github.com/vim/vim/issues/993#issuecomment-255651605
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  ]]
end

vim.cmd [[
silent !mkdir -p ~/.cache/nvim/undo > /dev/null 2>&1
]]
vim.opt.undofile = true
vim.opt.undodir = vim.loop.os_homedir()..'/.cache/nvim/undo'

vim.g.backup = false
vim.g.writebackup = false
vim.g.swapfile = false

if U.has('nvim-0.7') then
  -- Use Neovim way of detecting filetypes
  -- vim.g.did_load_filetypes = false
  -- vim.g.do_filetype_lua = true

  -- Global status line
  vim.opt.laststatus = 3
else
  vim.opt.laststatus = 2
end

if U.is_mac then
  vim.o.clipboard = 'unnamed'
  vim.go.python_host_prog = '/usr/bin/python'
  vim.go.python3_host_prog = '/usr/local/bin/python3'
  vim.go.python2_host_prog = '/usr/bin/python2'
end

if U.is_linux then
  vim.o.clipboard = 'unnamedplus'
end

if U.has('python') then
  vim.opt.pyx=3
end

vim.opt.diffopt:append { 'vertical' }
vim.opt.mouse = 'a'

vim.opt.tabstop = 2
vim.opt.backspace = {"indent", "eol", "start"}
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.shiftround = true
vim.opt.joinspaces = false

vim.opt.textwidth = 80
vim.opt.colorcolumn = "+1"

vim.opt.listchars:append { trail = "·", precedes = "←", extends = "→", tab = "¬ ", nbsp = "+", conceal = "※" }
vim.opt.fillchars:append { vert = ' ' }
vim.opt.list = true

vim.o.shortmess = vim.o.shortmess..'c'

-- Netrw, make it more like a project drawer
vim.g.netrw_preview = 1
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 30
vim.g.netrw_banner = 0

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.autowrite = true
vim.opt.cursorline = true
vim.opt.ruler = true
vim.opt.number = true
vim.opt.redrawtime = 10000

if U.executable('rg') then
  vim.opt.grepprg = "rg --vimgrep"
end
