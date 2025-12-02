vim.cmd [[
  augroup vimrcEx
    autocmd!

    " Open to last line after close
    autocmd BufReadPost *
      \ if &ft != 'gitcommit' && line("'\"") > 1 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif

    " JSON w/ comments
    autocmd FileType json syntax match Comment +\/\/.\+$+

    " Resize panes when window resizes
    autocmd VimResized * :wincmd =
  augroup END
]]

vim.cmd [[
  augroup netrwEx
    " Turn off line numbers in file tree
    autocmd FileType netrw setlocal nonumber norelativenumber
    autocmd FileType netrw setlocal colorcolumn=
  augroup END
]]

vim.cmd [[
  augroup terminalEx
    " Turn off line numbers in :terminal
    au TermOpen * setlocal nonumber norelativenumber nocursorline
    au TermOpen * set winhighlight=Normal:BlackBg
  augroup END
]]

-- Clean up buffers when switching projects
vim.api.nvim_create_autocmd('DirChanged', {
  group = vim.api.nvim_create_augroup('ProjectSwitchCleanup', { clear = true }),
  pattern = 'global',
  callback = function()
    local new_cwd = vim.fn.getcwd()
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
          and not vim.startswith(bufname, new_cwd) then
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
    if #modified_buffers > 0 then
      local choice = vim.fn.confirm(
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
    if total_closed > 0 then
      vim.notify(
        string.format('Closed %d buffer(s) from previous project', total_closed),
        vim.log.levels.INFO
      )
    end
  end,
  desc = 'Clean up buffers when switching projects'
})
