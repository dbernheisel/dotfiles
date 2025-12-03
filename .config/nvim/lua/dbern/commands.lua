-- Other Editors
vim.cmd [[
  command! Intellij execute ":!idea %:p --line " . line('.')
  command! VSCode execute ":!code -g %:p\:" . line('.') . ":" . col('.')
]]

-- Clean buffers outside current project
vim.api.nvim_create_user_command('CleanOldBuffers', function()
  require('dbern.buffer_cleanup').cleanup_old_buffers()
end, { desc = 'Close buffers outside current project' })

