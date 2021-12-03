lua require('dbern.lsp')

command! -nargs=0 Format :lua vim.lsp.buf.formatting()
command! -nargs=? LspActiveClients lua print(vim.inspect(vim.lsp.get_active_clients()))
command! -nargs=? LspLog lua vim.api.nvim_command("split "..vim.lsp.get_log_path())

function! RestartLsp()
  lua vim.lsp.stop_client(vim.lsp.get_active_clients())
  edit
endfunction

nnoremap <silent> <leader>tr :TroubleToggle lsp_document_diagnostics<CR>
nnoremap <silent> <leader>TR :TroubleToggle lsp_workspace_diagnostics<CR>

command! -nargs=? LspRestart :call RestartLsp()

sign define DiagnosticSignError text=⨯ texthl=DiagnosticSignError linehl= numhl=
sign define DiagnosticSignWarn text=⚠ texthl=DiagnosticSignWarn linehl= numhl=
sign define DiagnosticSignInfo text= texthl=DiagnosticSignInfo linehl= numhl=
sign define DiagnosticSignHint text= texthl=DiagnosticSignHint linehl= numhl=
