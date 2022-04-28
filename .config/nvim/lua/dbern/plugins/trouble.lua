local trouble = require("trouble")

trouble.setup({
  auto_preview = false,
  use_diagnostic_signs = true,
  action_keys = {
    jump = {},
    jump_close = {"o", "<cr>", "<tab>"}
  }
})

vim.api.nvim_set_keymap('n', '<leader>tr', ':TroubleToggle document_diagnostics<cr>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<leader>TR', ':TroubleToggle lsp_workspace_diagnostics<cr>', { silent = true, noremap = true })

