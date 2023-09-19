local ts_configs = require('nvim-treesitter.configs')

local M = {}
M.setup = function()
  ts_configs.setup({
    ensure_installed = {
      'bash', 'css', 'dart', 'dockerfile', 'erlang', 'elixir', 'go', 'eex',
      'heex', 'html', 'javascript', 'jsonc', 'kotlin', 'lua', 'markdown',
      'markdown_inline', 'php', 'python', 'regex', 'ruby', 'rust', 'scss',
      'surface', 'svelte', 'toml', 'tsx', 'typescript', 'vue', 'yaml', 'zig'
    },
    indent = { enable = true },
    highlight = { enable = true },
    incremental_selection = { enable = true },
    textobjects = { enable = true },
  })
end

return M
