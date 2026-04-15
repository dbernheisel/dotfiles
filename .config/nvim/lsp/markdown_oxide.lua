return {
  cmd = { 'markdown-oxide' },
  filetypes = { 'markdown' },
  capabilities = {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true
      }
    }
  },
}
