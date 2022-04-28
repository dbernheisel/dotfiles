vim.g.ultest_running_sign = "ﰌ"
vim.g.ultest_summary_width = 75

vim.api.nvim_set_keymap('n', '<leader>ta', ':UltestAttach<cr>', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>to', '<Plug>(ultest-output-jump)<cr>', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>ts', ':UltestSummary!<cr>', { silent = true })
