local a = vim.api
local lspconfig = require('lspconfig')
local lua_lsp_root = vim.loop.os_homedir().."/.cache/lua-language-server"
local lua_lsp_bin
local os = vim.loop.os_uname().sysname
if os == "Darwin" then
  lua_lsp_bin = lua_lsp_root.."/bin/macOS/lua-language-server"
elseif os == "Linux" then
  lua_lsp_bin = lua_lsp_root.."/bin/Linux/lua-language-server"
end

local nullls  = require('null-ls')
nullls.setup({
  sources = {
    nullls.builtins.diagnostics.credo,
    nullls.builtins.formatting.zigfmt,
    nullls.builtins.formatting.surface,
    nullls.builtins.diagnostics.shellcheck,
    nullls.builtins.diagnostics.yamllint,
    nullls.builtins.formatting.prettierd,
    nullls.builtins.diagnostics.rubocop.with({
      command = function(_params)
        if vim.fn.glob("scripts/bin/rubocop-daemon/rubocop") ~= "" then
          return "scripts/bin/rubocop-daemon/rubocop"
        else
          return "bundle"
        end
      end,
      args = function(params)
        if params.cmd == "bundle" then
          return vim.list_extend({ "exec", "rubocop" }, require("null-ls").builtins.diagnostics.rubocop._opts.args)
        else
          return {}
        end
      end
    }),
    nullls.builtins.formatting.eslint_d.with({
      cwd = function(params)
        return lspconfig.util.root_pattern(".eslintrc.js")(params.bufname)
      end
    }),
    nullls.builtins.diagnostics.eslint_d.with({
      cwd = function(params)
        return lspconfig.util.root_pattern(".eslintrc.js")(params.bufname)
      end
    }),
    nullls.builtins.code_actions.eslint_d.with({
      cwd = function(params)
        return lspconfig.util.root_pattern(".eslintrc.js")(params.bufname)
      end
    })
  }
})

local lsp_servers = {
  bashls = {},
  cssls = {
    root_dir = lspconfig.util.root_pattern("package.json", ".git")
  },
  dockerls = {},
  elixirls = {
    cmd = { vim.loop.os_homedir().."/.cache/elixir-ls/release/language_server.sh" },
    settings = {
      elixirLS = {
        dialyzerFormat = "dialyxir_short";
      }
    }
  },
  html = {
    cmd = { "html-languageserver", "--stdio" },
    filetypes = {"html", "eelixir", "eruby"}
  },
  jsonls = {},
  solargraph = {
    filetypes = {"ruby"}
  },
  sorbet = {
    cmd = { "srb", "tc", "--lsp" },
    filetypes = { "ruby" },
    root_dir = lspconfig.util.root_pattern('sorbet'),
  },
  sqlls = {
    cmd = {"sql-language-server", "up", "--method", "stdio"},
  },
  sumneko_lua = {
    cmd = { lua_lsp_bin, "-E", lua_lsp_root.."/main.lua" },
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
  -- tailwindcss = {
  --   cmd = { vim.loop.os_homedir().."/.cache/tailwindcss-intellisense/tailwindcss-language-server", "--stdio" },
  -- },
  tsserver = {},
  vimls = {},
  vuels = {},
  yamlls = {},
}

local function make_on_attach(config)
  return function(client)
    print('LSP Starting')

    local opts = { noremap = true, silent = true }
    a.nvim_buf_set_keymap(0, 'n', 'K',  '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    a.nvim_buf_set_keymap(0, 'n', '<c-space>', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    a.nvim_buf_set_keymap(0, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    a.nvim_buf_set_keymap(0, 'n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    a.nvim_buf_set_keymap(0, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    a.nvim_buf_set_keymap(0, 'n', '<leader>gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    a.nvim_buf_set_keymap(0, 'n', '<leader>gs', '<cmd>lua vim.lsp.buf.document_symbol()<cr>', opts)
    a.nvim_buf_set_keymap(0, 'n', '<leader>gw', '<cmd>lua vim.lsp.buf.workspace_symbol()<cr>', opts)
    a.nvim_buf_set_keymap(0, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    a.nvim_buf_set_keymap(0, 'n', '<leader>gi', '<cmd>lua vim.lsp.buf.incoming_calls()<cr>', opts)
    a.nvim_buf_set_keymap(0, 'n', '<leader>go', '<cmd>lua vim.lsp.buf.outgoing_calls()<cr>', opts)
    a.nvim_buf_set_keymap(0, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)

    if client.resolved_capabilities.document_highlight == true then
      a.nvim_command('augroup lsp_aucmds')
      a.nvim_command('au CursorHold <buffer> lua vim.lsp.buf.document_highlight()')
      a.nvim_command('au CursorMoved <buffer> lua vim.lsp.buf.clear_references()')
      a.nvim_command('augroup END')
    end

    a.nvim_command('setlocal omnifunc=v:lua.vim.lsp.omnifunc')
  end
end

-- Add snippet support
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

for lsp_server, config in pairs(lsp_servers) do
  config.on_attach = make_on_attach(config)
  config.capabilities = capabilities

  if lsp_server == 'sorbet' and vim.fn.glob("scripts/bin/typecheck") ~= "" then
    config.cmd = {
      "scripts/dev_productivity/while_pay_up_connected.sh",
      "pay",
      "exec",
      "scripts/bin/typecheck",
      "--lsp",
      "--enable-all-experimental-lsp-features",
      "--enable-experimental-lsp-document-formatting-rubyfmt"
    }
  elseif lsp_server == 'solargraph' and vim.fn.glob("scripts/bin/typecheck") ~= "" then
    config.filetypes = {}
  elseif lsp_server == 'solargraph' and vim.fn.glob("sorbet") ~= "" then
    config.filetypes = {}
  elseif lsp_server == 'sorbet' then
    local local_sorbet_build = vim.fn.glob(vim.fn.environ().HOME.."/stripe/sorbet/bazel-bin/main/sorbet")
    if local_sorbet_build ~= "" then
      -- prefer a local build of sorbet if it's available
      config.cmd = {
        local_sorbet_build,
        "--lsp",
        "--silence-dev-message",
        "--enable-all-experimental-lsp-features",
        "--enable-experimental-lsp-document-formatting-rubyfmt"
      }
    end
  end

  lspconfig[lsp_server].setup(config)
end

require('colorizer').setup({
  'css',
  'scss',
  'sass',
  'javascript',
  'html',
  'lua',
  'vim',
  'conf',
  'eelixir',
  'erb'
})
