local telescope = require('telescope')
local actions = require('telescope.actions')
local builtin = require('telescope.builtin')

local M = {}

M.setup = function()
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

  -- Avoiding Telescope since I'm working in a monorepo now :(
  --
  -- nnoremap <silent> <c-p> :lua require('dbern.plugins.telescope').find_files()<CR>
  -- nnoremap <silent> <c-f> :lua require('dbern.plugins.telescope').find_files()<CR>
  -- nnoremap <silent> <leader>f :lua require('telescope.builtin').grep_string({ search = vim.fn.input("> ")})<CR>
  -- nnoremap <silent> <leader>cw :lua require('telescope.builtin').grep_string({ search = vim.fn.expand("<cword>") })<CR>
  vim.api.nvim_set_keymap('n', '<leader>F', ':Telescope lsp_workspace_symbols query=', { noremap = true })

  vim.cmd [[

    nnoremap <silent> <leader>ev :lua require('dbern.plugins.telescope').search_vimrc()<CR>
    nnoremap <silent> <leader>ed :lua require('dbern.plugins.telescope').search_dotfiles()<CR>
    nnoremap <silent> <leader>el :lua require('dbern.plugins.telescope').search_local()<CR>
    nnoremap <silent> <leader>ca :lua require('dbern.plugins.telescope').code_actions()<CR>

    nnoremap <silent> <leader>gb :lua require('dbern.plugins.telescope').git_branches()<CR>
  ]]
end

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
