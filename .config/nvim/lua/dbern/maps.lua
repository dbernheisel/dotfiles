local m = vim.api.nvim_set_keymap
local U = require('dbern.utils')

-- Bash-like command complete selection
m('c', '<left>', '<space><bs><left>', { noremap = true })
m('c', '<right>', '<space><bs><right>', { noremap = true })

-- Source config again
m('n', '<leader>sv', ':source $MYVIMRC<cr>', { noremap = true })

-- Turn off linewise up and down movements
m('n', 'j', 'gj', {})
m('n', 'k', 'gk', {})

if U.has('nvim-0.10') then
  vim.keymap.set({'n', 'x', 'o'}, '<leader>/', 'gc', { silent = true, remap = true })
end

-- Disable Documentation Lookup
m('', 'K', '', {})

m('', '<cr>', ":nohl<cr>", { silent = true })

-- Map keys for moving between splits
m('n', '<c-h>', '<c-w><c-h>', { noremap = true })
m('n', '<c-j>', '<c-w><c-j>', { noremap = true })
m('n', '<c-k>', '<c-w><c-k>', { noremap = true })
m('n', '<c-l>', '<c-w><c-l>', { noremap = true })

-- Get off my lawn
m('i', '<up>', '', {})
m('i', '<down>', '', {})
m('i', '<left>', '', {})
m('i', '<right>', '', {})

-- Change Tabs
m('n', '<c-left>', ':tabprevious<cr>', { noremap = true, silent = true })
m('n', '<c-right>', ':tabnext<cr>', { noremap = true, silent = true })

-- semicolon as colon
m('', ';', ':', {})

-- jj maps to Esc while in insert mode
m('i', 'jj', '<esc>', { noremap = true })

-- Move lines up and down
m('n', '<A-k>', ':move .-2<cr>==', { noremap = true, silent = true })
m('n', '<A-j>', ':move .+1<cr>==', { noremap = true, silent = true })
m('i', '<A-k>', '<Esc>:move .-2<cr>==gi', { noremap = true, silent = true })
m('i', '<A-j>', '<Esc>:move .+1<cr>==gi', { noremap = true, silent = true })
m('v', '<A-k>', ':move \'<-2<cr>gv=gv', { noremap = true})
m('v', '<A-j>', ':move \'>+1<cr>gv=gv', { noremap = true})
m('n', '<A-h>', '<<', { noremap = true, silent = true })
m('n', '<A-l>', '>>', { noremap = true, silent = true })

m('n', '<leader><leader>', '<c-^>', { noremap = true })

function _G.show_documentation()
  local filetype = vim.bo.filetype

  if filetype == 'vim' or filetype == 'help' or filetype == 'lua' then
    vim.api.nvim_command('h '..vim.fn.expand('<cword>'))
  end
end

m('n', 'gd', ':call v:lua.show_documentation()<cr>', { silent = true })

-- Emulate tmux shortcuts
-- Remember to use :tabclose instead of :q for zoomed terminals
m('n', [[<C-A>z]], ':$tabnew<CR>:terminal<CR>i', { noremap = true })
m('n', [[<C-A>\]], ':80vsplit term://$SHELL<CR>i', { noremap = true })
m('n', [[<C-A>-]], ':split term://$SHELL<CR>i', { noremap = true })

m('t', [[<C-O>]], [[<C-\><C-N>]], { noremap = true })
m('t', [[<A-H>]], [[<C-\><C-N><C-W>h]], { noremap = true })
m('t', [[<A-J>]], [[<C-\><C-N><C-W>j]], { noremap = true })
m('t', [[<A-K>]], [[<C-\><C-N><C-W>k]], { noremap = true })
m('t', [[<A-L>]], [[<C-\><C-N><C-W>l]], { noremap = true })
m('i', [[<A-H>]], [[<C-\><C-N><C-W>h]], { noremap = true })
m('i', [[<A-J>]], [[<C-\><C-N><C-W>j]], { noremap = true })
m('i', [[<A-K>]], [[<C-\><C-N><C-W>k]], { noremap = true })
m('i', [[<A-L>]], [[<C-\><C-N><C-W>l]], { noremap = true })
