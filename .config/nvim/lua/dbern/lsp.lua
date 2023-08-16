local a = vim.api
local lspconfig = require('lspconfig')
local lspconfig_configs = require('lspconfig.configs')
local mason = require('mason')
local mason_lspconfig = require('mason-lspconfig')
local cmp_nvim_lsp = require('cmp_nvim_lsp')
local document_color  = require('document-color')
local hasFzf, _Fzf = pcall(require, "fzf-lua")
local elixir = require('elixir')
local elixirls = require('elixir.elixirls')

local lspHighlightAugroup = vim.api.nvim_create_augroup("LspDocumentHighlight", {})

local function make_on_attach(_config)
  return function(client, bufnr)
    -- print("LSP "..client.name.." starting...")

    local opts = { noremap = true, silent = true }
    a.nvim_buf_set_keymap(bufnr, 'n', 'K',  '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    a.nvim_buf_set_keymap(bufnr, 'n', '<c-space>', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    a.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    a.nvim_buf_set_keymap(bufnr, 'n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    a.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)

    if hasFzf then
      a.nvim_buf_set_keymap(bufnr, 'n', '<leader>gr', '<cmd>FzfLua lsp_references<cr>', opts)
      a.nvim_buf_set_keymap(bufnr, 'n', '<leader>gs', '<cmd>FzfLua lsp_document_symbols<cr>', opts)
      a.nvim_buf_set_keymap(bufnr, 'n', '<leader>gw', '<cmd>FzfLua lsp_workspace_symbols<cr>', opts)
      a.nvim_buf_set_keymap(bufnr, 'n', '<leader>gi', '<cmd>FzfLua lsp_incoming_calls<cr>', opts)
      a.nvim_buf_set_keymap(bufnr, 'n', '<leader>go', '<cmd>FzfLua lsp_outgoing_calls<cr>', opts)
      a.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>FzfLua lsp_code_actions<cr>', opts)
    else
      a.nvim_buf_set_keymap(bufnr, 'n', '<leader>gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
      a.nvim_buf_set_keymap(bufnr, 'n', '<leader>gs', '<cmd>lua vim.lsp.buf.document_symbol()<cr>', opts)
      a.nvim_buf_set_keymap(bufnr, 'n', '<leader>gw', '<cmd>lua vim.lsp.buf.workspace_symbol()<cr>', opts)
      a.nvim_buf_set_keymap(bufnr, 'n', '<leader>gi', '<cmd>lua vim.lsp.buf.incoming_calls()<cr>', opts)
      a.nvim_buf_set_keymap(bufnr, 'n', '<leader>go', '<cmd>lua vim.lsp.buf.outgoing_calls()<cr>', opts)
      a.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
    end
    a.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)

    if client.supports_method("textDocument/documentColor") then
      document_color.buf_attach(bufnr)
    end

    if client.supports_method("textDocument/formatting") then
      -- Add :Format command
      a.nvim_buf_create_user_command(bufnr, 'Format', function()
        local params = require('vim.lsp.util').make_formatting_params({})
        client.request("textDocument/formatting", params, nil, bufnr)
      end, { nargs = 0 })
    end

    -- Highlight
    if client.supports_method("textDocument/documentHighlight") then
      a.nvim_clear_autocmds({ group = lspHighlightAugroup, buffer = bufnr })
      a.nvim_create_autocmd("CursorHold", {
        group = lspHighlightAugroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.document_highlight()
        end,
      })
      a.nvim_create_autocmd("CursorMoved", {
        group = lspHighlightAugroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.clear_references()
        end,
      })
    end

    a.nvim_command('setlocal omnifunc=v:lua.vim.lsp.omnifunc')
  end
end

-- :Mason
mason.setup()

    -- LSPs
    -- ruby-lsp ruby_ls
    -- bash-language-server bashls
    -- css-lsp cssls
    -- dockerfile-language-server dockerls
    -- elixir-ls elixirls
    -- erlang-ls erlangls
    -- eslint-lsp eslint
    -- html-lsp html
    -- json-lsp jsonls
    -- lua-language-server lua_ls
    -- sqlls
    -- tailwindcss-language-server tailwindcss
    -- typescript-language-server tsserver
    -- vetur-vls vuels
    -- vim-language-server vimls
    -- yaml-language-server yamlls
    -- zls

    -- Formatters
    -- erb-lint
    -- prettierd
    -- rubocop
    -- shellcheck
    -- solargraph
    -- sql-formatter
    -- tree-sitter-cli
mason_lspconfig.setup({
  ensure_installed = { "bashls", "cssls", "dockerls", "html", "jsonls",
    "solargraph", "lua_ls", "tailwindcss", "tsserver", "vimls",
    "vuels", "ruby_ls", "sqlls", "yamlls", "zls" }
})

-- This doesn't work yet
if not lspconfig_configs.lexical then
  lspconfig_configs.lexical = {
    default_config = {
      filetypes = { "elixir", "eelixir" },
      cmd = { "/Users/davidbernheisel/lexical/_build/dev/rel/lexical/start_lexical.sh" },
      settings = {},
      root_dir = function(fname)
        return lspconfig.util.root_pattern("mix.exs", ".git")(fname) or vim.loop.os_homedir()
      end,
    },
  }
end

local lsp_servers = {
  bashls = {},
  cssls = {},
  dockerls = {},
  html = {},
  jsonls = {},
  solargraph = {
    filetypes = {"ruby"}
  },
  sqlls = {},
  lua_ls = {
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
          path = vim.split(package.path, ';')
        },
        diagnostics = {
          globals = {'vim'},
        },
        workspace = {
          library = {
            [vim.fn.expand('$VIMRUNTIME/lua')] = true,
            [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
          }
        },
      },
    },
  },
  tailwindcss = {},
  tsserver = {},
  vimls = {},
  vuels = {},
  yamlls = {},
  zls = {},
}

-- Add snippet support
local capabilities = cmp_nvim_lsp.default_capabilities()

for lsp_server, config in pairs(lsp_servers) do
  config.on_attach = make_on_attach(config)
  config.capabilities = capabilities
  lspconfig[lsp_server].setup(config)
end

elixir.setup({
  credo = {
    enable = false
  },
  nextls = {
    enable = false,
    version = "0.8.1",
    on_attach = make_on_attach({})
  },
  elixirls = {
    enable = true,
    tag = "v0.15.1",
    settings = elixirls.settings({
      enableTestLenses = false
    }),
    on_attach = function(client, bufnr)
      vim.keymap.set("n", "<space>pf", ":ElixirFromPipe<cr>", { buffer = true, noremap = true })
      vim.keymap.set("n", "<space>pt", ":ElixirToPipe<cr>", { buffer = true, noremap = true })
      vim.keymap.set("v", "<space>em", ":ElixirExpandMacro<cr>", { buffer = true, noremap = true })

      a.nvim_buf_create_user_command(bufnr, 'Format', function()
        local params = require('vim.lsp.util').make_formatting_params({})
        client.request("textDocument/formatting", params, nil, bufnr)
      end, { nargs = 0 })
    end
  }
  -- actually lexical
--   elixirls = {
--     enable = true,
--     settings = elixirls.settings({
--       enableTestLenses = false
--     }),
--     cmd = "/Users/davidbernheisel/lexical/_build/dev/rel/lexical/start_lexical.sh",
--     on_attach = function(client, bufnr)
--       a.nvim_buf_create_user_command(bufnr, 'Format', function()
--         local params = require('vim.lsp.util').make_formatting_params({})
--         client.request("textDocument/formatting", params, nil, bufnr)
--       end, { nargs = 0 })
--     end
--   }
 })

require('colorizer').setup({
  'css',
  'scss',
  'sass',
  'javascript',
  'html',
  'svg',
  'lua',
  'vim',
  'svg',
  'conf',
  'eelixir',
  'elixir',
  'heex',
  'erb'
})
