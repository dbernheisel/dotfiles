require('nvim-treesitter.configs').setup({
    ensure_installed = {'bash', 'css', 'dart', 'elixir', 'dockerfile', 'erlang',
    'go', 'html', 'javascript', 'jsonc', 'kotlin', 'lua', 'php', 'python',
    'regex', 'ruby', 'rust', 'scss', 'svelte', 'toml', 'tsx', 'typescript', 'vue',
    'yaml', 'zig'},

    indent = { enable = true },
    highlight = { enable = true },
    incremental_selection = { enable = true },
    textobjects = { enable = true },
  })

local M = {}
return M
