local parser_config = require('nvim-treesitter.parsers').get_parser_configs()

local read_query = function(filename)
  return table.concat(vim.fn.readfile(vim.fn.expand(filename)), "\n")
end

local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
-- parser_config.elixir = {
--   install_info = {
--     url = '~/tree-sitter-elixir',
--     files =  { 'src/parser.c', 'src/scanner.cc' },
--     requires_generate_from_grammar  = true,
--   }
-- }

-- parser_config.html_eex = {
--   install_info = {
--     url = 'https://github.com/tree-sitter/tree-sitter-embedded-template',
--     files =  { 'src/parser.c' },
--     requires_generate_from_grammar  = true,
--   },
--   filetype = "eelixir",
--   used_by = {'eex', 'eelixir'}
-- }
--
-- parser_config.html_erb = {
--   install_info = {
--     url = 'https://github.com/tree-sitter/tree-sitter-embedded-template',
--     files =  { 'src/parser.c' },
--     requires_generate_from_grammar  = true,
--   },
--   used_by = {'eruby'}
-- }

parser_config.embedded_template = {
  install_info = {
    url = 'https://github.com/tree-sitter/tree-sitter-embedded-template',
    files =  { 'src/parser.c' }
  },
  filetype = "eelixir",
  used_by = {'eex', 'eelixir', 'eruby'}
}

parser_config.markdown = {
  install_info = {
    url = 'https://github.com/ikatyang/tree-sitter-markdown',
    files =  { 'src/parser.c', 'src/scanner.cc', "-DTREE_SITTER_MARKDOWN_AVOID_CRASH=1" },
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
