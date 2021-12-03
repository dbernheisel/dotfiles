local actions = require('telescope.actions')
local utils = require('telescope.utils')

require('telescope').setup({
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
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
    file_ignore_patterns = { "^node_modules/" },
    winblend = 10,
    layout_config = {
      width = 0.8,
    },
    show_line = false,
    prompt_title = '',
    results_title = '',
    preview_title = '',
    borderchars = {
      prompt =  {'-', ' ', '-', ' ', '-', '-', '-', '-' },
      results = {'-', ' ', ' ', ' ', '-', '-', ' ', ' ' },
      preview = {'-', ' ', '-', ' ', '-', '-', ' ', ' ' },
    },
  }
})

require('telescope').load_extension('fzf')

local M = {}

M.find_files = function()
  require('telescope.builtin').fd({
    previewer = false
  })
end

M.find_git_files = function()
  require('telescope.builtin').git_files({
    previewer = false
  })
end

M.file_browser = function()
  require('telescope.builtin').file_browser({
    hidden = true,
  })
end

M.file_browser_from_buffer = function()
  require('telescope.builtin').file_browser({
    hidden = true,
    cwd = utils.buffer_dir()
  })
end

M.search_dotfiles = function()
  require('telescope.builtin').fd({
    prompt_title = "dotfiles",
    cwd = "~/.config/",
    file_ignore_patterns = { "^coc/", "^yarn/", "^nvim/", "^pulse/", "^kak/plugins/" }
  })
end

M.search_local = function()
  require('telescope.builtin').fd({
    prompt_title = "dotfiles",
    cwd = "~/.local/",
    file_ignore_patterns = { "^kitty.app/", "^lib/", "^share/", "^discord/", "^Insomnia Designer/", "^BraveSoftware/" }
  })
end

M.search_workspace_lsp = function()
  require('telescope.builtin').lsp_workspace_symbols({
    prompt_title = "Rubies",
    opts = {
      file_ignore_patterns = { "^generated/", "^.vscode/", "^sorbet/", "^build/" }
    }
  })
end

M.code_actions = function()
  require('telescope.builtin').lsp_code_actions({
    prompt_title = "Code Actions"
  })
end

M.search_vimrc = function()
  require('telescope.builtin').fd({
    prompt_title = "nvimrc",
    cwd = "~/.config/nvim",
    hidden = true,
    file_ignore_patterns = { ".netrwhist", "undo/.*", "plugged/.*" }
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
