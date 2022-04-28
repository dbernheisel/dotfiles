vim.g.neo_tree_remove_legacy_commands = true
local neotree = require('neo-tree')

local M = {}

M.setup = function()
  neotree.setup({
    enable_git_status = false,
    enable_diagnostics = false,
    close_if_last_window = false,
    filesystem = {
      use_libuv_file_watcher = true,
      hijack_netrw_behavior = "open_default",
      window = {
        popup = {
          position = { col = "0%", row = "0" },
          size = function(state)
            local root_name = vim.fn.fnamemodify(state.path, ":~")
            local root_len = string.len(root_name) + 4
            return {
              width = math.max(root_len, 50),
              height = vim.o.lines - 6
            }
          end
        }
      }
    }
  })

  vim.api.nvim_set_keymap('n', '<leader>b', ':Neotree float reveal<cr>', { silent = true, noremap = true })
end

return M
