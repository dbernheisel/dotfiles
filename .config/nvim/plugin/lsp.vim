lua require('dbern.lsp')

command! -nargs=0 Format :lua vim.lsp.buf.formatting()
command! -nargs=? LspActiveClients lua print(vim.inspect(vim.lsp.get_active_clients()))
command! -nargs=? LspLog lua vim.api.nvim_command("split "..vim.lsp.get_log_path())

function! RestartLsp()
  lua vim.lsp.stop_client(vim.lsp.get_active_clients())
  edit
endfunction

command! -nargs=? LspRestart :call RestartLsp()

sign define LspDiagnosticsSignError text=⨯ texthl=LspDiagnosticsSignError linehl= numhl=
sign define LspDiagnosticsSignWarning text=⚠ texthl=LspDiagnosticsSignWarning linehl= numhl=
sign define LspDiagnosticsSignInformation text= texthl=LspDiagnosticsSignInformation linehl= numhl=
sign define LspDiagnosticsSignHint text= texthl=LspDiagnosticsSignHint linehl= numhl=
