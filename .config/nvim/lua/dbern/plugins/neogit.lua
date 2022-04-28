local neogit = require('neogit')
neogit.setup({})

vim.api.nvim_set_keymap('n', '<leader>g', ':Neogit<cr>', { noremap = true, silent = true })
