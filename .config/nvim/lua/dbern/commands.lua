-- Other Editors
vim.cmd [[
  command! Intellij execute ":!idea %:p --line " . line('.')
  command! VSCode execute ":!code -g %:p\:" . line('.') . ":" . col('.')
]]

-- Clean buffers outside current project
vim.api.nvim_create_user_command('CleanOldBuffers', function()
  local cwd = vim.fn.getcwd()
  local unmodified_buffers = {}
  local modified_buffers = {}

  -- Categorize buffers
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) then
      local bufname = vim.api.nvim_buf_get_name(bufnr)
      local buftype = vim.bo[bufnr].buftype
      local modified = vim.bo[bufnr].modified

      if bufname ~= ''
        and buftype == ''
        and not vim.startswith(bufname, cwd) then
        if modified then
          table.insert(modified_buffers, bufnr)
        else
          table.insert(unmodified_buffers, bufnr)
        end
      end
    end
  end

  -- Close unmodified buffers automatically
  for _, bufnr in ipairs(unmodified_buffers) do
    vim.api.nvim_buf_delete(bufnr, { force = false })
  end

  -- Prompt for modified buffers
  local choice = 2
  if #modified_buffers > 0 then
    choice = vim.fn.confirm(
      string.format('%d modified buffer(s) from old project. Close anyway?', #modified_buffers),
      '&Yes\n&No\n&Save and Close',
      2
    )

    if choice == 1 then -- Yes, force close
      for _, bufnr in ipairs(modified_buffers) do
        vim.api.nvim_buf_delete(bufnr, { force = true })
      end
    elseif choice == 3 then -- Save and close
      for _, bufnr in ipairs(modified_buffers) do
        vim.api.nvim_buf_call(bufnr, function()
          vim.cmd('write')
        end)
        vim.api.nvim_buf_delete(bufnr, { force = false })
      end
    end
  end

  local total_closed = #unmodified_buffers + (#modified_buffers > 0 and (choice == 1 or choice == 3) and #modified_buffers or 0)
  vim.notify(
    string.format('Closed %d buffer(s) outside current project', total_closed),
    vim.log.levels.INFO
  )
end, { desc = 'Close buffers outside current project' })

