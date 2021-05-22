local actions = require('telescope.actions')
local sorters = require('telescope.sorters')

require('telescope').setup({
  extensions = {
    fzf = {
      override_generic_sorter = false,
      override_file_sorter = true,
      case_mode = "smart_case",
    }
  },
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case'
    },
    mappings = {
      i = {
        ["<esc>"] = actions.close,
        ["<c-j>"] = actions.move_selection_better,
        ["<c-k>"] = actions.move_selection_worse,
      }
    },
    file_ignore_patterns = {},
    winblend = 10,
    width = 0.8,
    show_line = false,
    borderchars = {
      prompt = {'▀', '▐', '▄', '▌', '▛', '▜', '▟', '▙' },
      results = {'▀', '▐', '▄', '▌', '▛', '▜', '▟', '▙' },
      preview = {'▀', '▐', '▄', '▌', '▛', '▜', '▟', '▙' },
    },
  }
})

require('telescope').load_extension('fzf')

local M = {}

M.search_dotfiles = function()
  require('telescope.builtin').fd({
    prompt_title = "dotfiles",
    cwd = "~/.config/",
    file_ignore_patterns = { "coc/.*", "yarn/.*", "nvim/.*", "pulse/.*", "kak/plugins/.*" }
  })
end

M.search_local = function()
  require('telescope.builtin').fd({
    prompt_title = "dotfiles",
    cwd = "~/.local/",
    file_ignore_patterns = { "kitty.app/.*", "lib/.*", "share/.*" }
  })
end

M.search_vimrc = function()
  require('telescope.builtin').fd({
    prompt_title = "nvimrc",
    cwd = "~/.config/nvim",
    hidden = true,
    file_ignore_patterns = { "undo/.*", "plugged/.*" }
  })
end

M.git_branches = function()
  require("telescope.builtin").git_branches({
    attach_mappings = function(_, map)
      map('i', '<c-d>', actions.git_delete_branch)
      map('n', '<c-d>', actions.git_delete_branch)
      return true
    end
  })
end

return M
