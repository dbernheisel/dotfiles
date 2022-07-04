command! -nargs=? LspActiveClients lua print(vim.inspect(vim.lsp.get_active_clients()))
command! -nargs=? LspLog lua vim.api.nvim_command("split "..vim.lsp.get_log_path())

function! NullStopLsp()
  let g:disable_null_ls = v:true
  lua vim.lsp.stop_client(vim.lsp.get_active_clients())
  lua vim.diagnostic.hide()
endfunction

function! RestartLsp()
  lua vim.lsp.stop_client(vim.lsp.get_active_clients())
  edit
endfunction

command! -nargs=? LspRestart :call RestartLsp()
command! -nargs=? NullStopLsp :call NullStopLsp()

sign define DiagnosticSignError text=⨯ texthl=DiagnosticSignError linehl= numhl=
sign define DiagnosticSignWarn text=⚠ texthl=DiagnosticSignWarn linehl= numhl=
sign define DiagnosticSignInfo text= texthl=DiagnosticSignInfo linehl= numhl=
sign define DiagnosticSignHint text= texthl=DiagnosticSignHint linehl= numhl=
