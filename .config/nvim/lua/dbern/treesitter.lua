local parser_config = require('nvim-treesitter.parsers').get_parser_configs()

parser_config.embedded_template = {
  install_info = {
    url = 'https://github.com/tree-sitter/tree-sitter-embedded-template',
    files =  { 'src/parser.c' },
    requires_generate_from_grammar  = true,
  },
  used_by = {'eex', 'leex', 'eelixir', 'eruby', 'erb'}
}

parser_config.markdown = {
  install_info = {
    url = 'https://github.com/ikatyang/tree-sitter-markdown',
    files =  { 'src/parser.c', 'src/scanner.cc', "-DTREE_SITTER_MARKDOWN_AVOID_CRASH=1" },
    requires_generate_from_grammar  = true,
  }
}

require('nvim-treesitter.configs').setup({
    ensure_installed = {
      'bash', 'css', 'dart', 'dockerfile', 'erlang', 'elixir',
      'embedded_template', 'go', 'heex', 'html', 'javascript', 'jsonc', 'kotlin',
      'lua', 'php', 'python', 'regex', 'ruby', 'rust', 'scss', 'surface',
      'svelte', 'toml', 'tsx', 'typescript', 'vue', 'yaml', 'zig'
    },

    indent = { enable = true },
    highlight = { enable = true },
    incremental_selection = { enable = true },
    textobjects = { enable = true },
  })

local M = {}
return M
