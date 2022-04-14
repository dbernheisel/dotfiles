local parser_config = require('nvim-treesitter.parsers').get_parser_configs()

require('nvim-treesitter.configs').setup({
    ensure_installed = {
      'bash', 'css', 'dart', 'dockerfile', 'erlang', 'elixir',
      'embedded_template', 'go', 'eex', 'heex', 'html', 'javascript', 'jsonc',
      'kotlin', 'lua', 'markdown', 'php', 'python', 'regex', 'ruby', 'rust',
      'scss', 'surface', 'svelte', 'toml', 'tsx', 'typescript', 'vue', 'yaml',
      'zig'
    },

    indent = { enable = true },
    highlight = { enable = true },
    incremental_selection = { enable = true },
    textobjects = { enable = true },
  })

local M = {}
return M
