return {
  cmd = { 'bash-language-server', 'start' },
  filetypes = { 'sh', 'bash', 'zsh' },
  settings = {
    bashIde = {
      globPattern = "*@(.sh|.inc|.bash|.command|.zsh|zshrc|zsh_*)"
    }
  },
}
