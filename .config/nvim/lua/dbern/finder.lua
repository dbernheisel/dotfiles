local telescope = require('telescope')
local actions = require('telescope.actions')
local builtin = require('telescope.builtin')
local utils = require('telescope.utils')

telescope.setup({
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

telescope.load_extension('fzf')

local M = {}

M.find_files = function()
  builtin.fd({
    previewer = false
  })
end

M.find_git_files = function()
  builtin.git_files({
    previewer = false
  })
end

if vim.fn.has('nvim-0.6') then
  telescope.load_extension('file_browser')

  M.file_browser = function()
    telescope.extensions.file_browser.file_browser({
      hidden = true,
    })
  end

  M.file_browser_from_buffer = function()
    telescope.extensions.file_browser.file_browser({
      hidden = true,
      cwd = utils.buffer_dir()
    })
  end
else
  M.file_browser = function()
    builtin.file_browser({
      hidden = true,
    })
  end

  M.file_browser_from_buffer = function()
    builtin.file_browser({
      hidden = true,
      cwd = utils.buffer_dir()
    })
  end
end

M.search_dotfiles = function()
  builtin.fd({
    prompt_title = "dotfiles",
    cwd = "~/.config/",
    file_ignore_patterns = { "^coc/", "^yarn/", "^nvim/", "^pulse/", "^kak/plugins/" }
  })
end

M.search_local = function()
  builtin.fd({
    prompt_title = "dotfiles",
    cwd = "~/.local/",
    file_ignore_patterns = { "^kitty.app/", "^lib/", "^share/", "^discord/", "^Insomnia Designer/", "^BraveSoftware/" }
  })
end

M.search_workspace_lsp = function()
  builtin.lsp_workspace_symbols({
    prompt_title = "Rubies",
    opts = {
      file_ignore_patterns = { "^generated/", "^.vscode/", "^sorbet/", "^build/" }
    }
  })
end

M.code_actions = function()
  builtin.lsp_code_actions({
    prompt_title = "Code Actions"
  })
end

M.search_vimrc = function()
  builtin.fd({
    prompt_title = "nvimrc",
    cwd = "~/.config/nvim",
    hidden = true,
    file_ignore_patterns = { ".netrwhist", "undo/.*", "plugged/.*" }
  })
end

M.git_branches = function()
  builtin.git_branches({
    attach_mappings = function(_, map)
      map('i', '<c-d>', actions.git_delete_branch)
      map('n', '<c-d>', actions.git_delete_branch)
      return true
    end
  })
end

return M
