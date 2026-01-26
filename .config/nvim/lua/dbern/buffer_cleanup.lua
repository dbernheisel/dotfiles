local M = {}

--- Categorize buffers into those inside and outside the current working directory
---@param cwd string The current working directory to compare against
---@return table unmodified List of unmodified buffer numbers outside cwd
---@return table modified List of modified buffer numbers outside cwd
local function categorize_buffers(cwd)
  local unmodified_buffers = {}
  local modified_buffers = {}

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

  return unmodified_buffers, modified_buffers
end

--- Close a list of buffers
---@param buffers table List of buffer numbers to close
---@param force boolean Whether to force close (ignore modifications)
local function close_buffers(buffers, force)
  for _, bufnr in ipairs(buffers) do
    if force then
      vim.api.nvim_buf_delete(bufnr, { force = true })
    else
      vim.api.nvim_buf_call(bufnr, function()
        vim.cmd('write')
      end)
      vim.api.nvim_buf_delete(bufnr, { force = false })
    end
  end
end

--- Clean up buffers outside the current working directory
---@param opts table|nil Options: { silent = boolean }
M.cleanup_old_buffers = function(opts)
  opts = opts or {}
  local cwd = vim.fn.getcwd()
  local unmodified_buffers, modified_buffers = categorize_buffers(cwd)

  -- Close unmodified buffers automatically
  for _, bufnr in ipairs(unmodified_buffers) do
    vim.api.nvim_buf_delete(bufnr, { force = false })
  end

  -- Prompt for modified buffers
  if #modified_buffers > 0 then
    vim.ui.select(
      { 'Discard changes', 'Keep open', 'Save and close' },
      {
        prompt = string.format('%d modified buffer(s) from old project:', #modified_buffers),
        format_item = function(item)
          return item
        end,
      },
      function(choice)
        if not choice then
          return
        end

        if choice == 'Discard changes' then
          close_buffers(modified_buffers, true)
        elseif choice == 'Save and close' then
          close_buffers(modified_buffers, false)
        end

        -- Calculate total closed
        local total_closed = #unmodified_buffers
        if choice == 'Discard changes' or choice == 'Save and close' then
          total_closed = total_closed + #modified_buffers
        end

        if not opts.silent and total_closed > 0 then
          vim.notify(
            string.format('Closed %d buffer(s) from previous project', total_closed),
            vim.log.levels.INFO
          )
        end
      end
    )
  else
    -- Only unmodified buffers were closed
    if not opts.silent and #unmodified_buffers > 0 then
      vim.notify(
        string.format('Closed %d buffer(s) from previous project', #unmodified_buffers),
        vim.log.levels.INFO
      )
    end
  end
end

return M
