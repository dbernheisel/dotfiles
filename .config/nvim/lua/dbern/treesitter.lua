local parser_config = require('nvim-treesitter.parsers').get_parser_configs()

local read_query = function(filename)
  return table.concat(vim.fn.readfile(vim.fn.expand(filename)), "\n")
end

parser_config.elixir = {
  install_info = {
    url = "https://github.com/ananthakumaran/tree-sitter-elixir",
    files =  { "src/parser.c", "src/scanner.cc" },
    requires_generate_from_grammar  = true,
  }
}

parser_config.markdown = {
  install_info = {
    url = "https://github.com/ikatyang/tree-sitter-markdown",
    files =  { "src/parser.c", "src/scanner.cc" },
    requires_generate_from_grammar  = true,
  }
}

require('nvim-treesitter.configs').setup({
    ensure_installed = {'bash', 'css', 'dart', 'dockerfile', 'erlang', 'elixir',
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
