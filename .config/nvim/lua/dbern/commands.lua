-- Other Editors
vim.cmd [[
  command! Intellij execute ":!idea %:p --line " . line('.')
  command! VSCode execute ":!code -g %:p\:" . line('.') . ":" . col('.')
]]
