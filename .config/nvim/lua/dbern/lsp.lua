local a = vim.api
local lspconfig = require('lspconfig')
local _lspconfig_configs = require('lspconfig.configs')
local lsputil = require 'lspconfig.util'
local mason = require('mason')
local mason_lspconfig = require('mason-lspconfig')
-- local cmp_nvim_lsp = require('cmp_nvim_lsp')
local hasFzf, _Fzf = pcall(require, "fzf-lua")
local elixir = require('elixir')
local elixirls = require('elixir.elixirls')
local u = require('dbern.utils')

local lspHighlightAugroup = vim.api.nvim_create_augroup("LspDocumentHighlight", {})

local function lsp_supports(client, method)
  local capability = vim.lsp._request_name_to_capability[method]
  if not capability then
    return false
  end

  if vim.tbl_get(client.server_capabilities, unpack(capability)) then
    return true
  else
    return false
  end
end


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

    if lsp_supports(client, "textDocument/formatting") then
      -- Add :Format command
      a.nvim_buf_create_user_command(bufnr, 'Format', function()
        local params = require('vim.lsp.util').make_formatting_params({})
        client.request("textDocument/formatting", params, nil, bufnr)
      end, { nargs = 0 })
    end

    -- Highlight
    if lsp_supports(client, "textDocument/documentHighlight") then
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
mason_lspconfig.setup({
  ensure_installed = { "bashls", "cssls", "dockerls", "html", "jsonls", "markdown_oxide",
    "solargraph", "kotlin_language_server", "lua_ls", "tailwindcss", "ts_ls", "vimls",
    "vuels", "ruby_lsp", "sqlls", "yamlls", "zls" }
})

local lsp_servers = {
  bashls = {},
  cssls = {},
  dockerls = {},
  html = {},
  jsonls = {},
  kotlin_language_server = {},
  markdown_oxide = {},
  ruby_lsp = {},
  sqlls = {},
  lua_ls = {},
  tailwindcss = {},
  ts_ls = {},
  vimls = {},
  vuels = {},
  yamlls = {},
  zls = {},
}

local sourcekit_lsp = '/Library/Developer/CommandLineTools/usr/bin/sourcekit-lsp'
if u.executable(sourcekit_lsp) then
  lsp_servers.sourcekit = {
    filetypes = {"swift"},
    cmd = { sourcekit_lsp }
  }
end

-- Add snippet support
-- local capabilities = cmp_nvim_lsp.default_capabilities()

for lsp_server, config in pairs(lsp_servers) do
  -- print("LSP "..lsp_server.." starting...")
  config.on_attach = make_on_attach(config)
  local capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
  config.capabilities = capabilities

  if lsp_server == "markdown_oxide" then
    config.capabilities.workspace = {
      didChangeWatchedFiles = { dynamicRegistration = true }
    }
  end

  lspconfig[lsp_server].setup(config)
end

elixir.setup({
  credo = {
    on_attach = make_on_attach({}),
    enable = false
  },
  nextls = {
    enable = false,
    version = "0.23.1",
    on_attach = make_on_attach({}),
    init_options = {
      experimental = {
        completions = {
          enable = true -- control if completions are enabled. defaults to false
        }
      }
    },
  },
  -- elixirls = {
  --   enable = true,
  --   tag = "v0.23.0",
  --   settings = elixirls.settings({
  --     enableTestLenses = false
  --   }),
  --   on_attach = function(client, bufnr)
  --     vim.keymap.set("n", "<space>pf", ":ElixirFromPipe<cr>", { buffer = true, noremap = true })
  --     vim.keymap.set("n", "<space>pt", ":ElixirToPipe<cr>", { buffer = true, noremap = true })
  --     vim.keymap.set("v", "<space>em", ":ElixirExpandMacro<cr>", { buffer = true, noremap = true })
  --
  --     a.nvim_buf_create_user_command(bufnr, 'Format', function()
  --       local params = require('vim.lsp.util').make_formatting_params({})
  --       client.request("textDocument/formatting", params, nil, bufnr)
  --     end, { nargs = 0 })
  --     make_on_attach({})(client, bufnr)
  --   end
  -- }
  -- actually lexical
  elixirls = {
    enable = true,
    settings = elixirls.settings({
      enableTestLenses = false
    }),
    cmd = os.getenv("HOME").."/lexical/_build/dev/package/lexical/bin/start_lexical.sh",
    on_attach = function(client, bufnr)
      vim.keymap.set("n", "<space>pf", ":ElixirFromPipe<cr>", { buffer = true, noremap = true })
      vim.keymap.set("n", "<space>pt", ":ElixirToPipe<cr>", { buffer = true, noremap = true })
      vim.keymap.set("v", "<space>em", ":ElixirExpandMacro<cr>", { buffer = true, noremap = true })

      a.nvim_buf_create_user_command(bufnr, 'Format', function()
        local params = require('vim.lsp.util').make_formatting_params({})
        client.request("textDocument/formatting", params, nil, bufnr)
      end, { nargs = 0 })
      make_on_attach({})(client, bufnr)
    end
  }
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
