local a = vim.api
local lspconfig = require('lspconfig')
local mason = require('mason')
local mason_install = require('mason-lspconfig')
local cmp_nvim_lsp = require('cmp_nvim_lsp')
local null_ls  = require('null-ls')
local document_color  = require('document-color')
local hasFzf, _Fzf = pcall(require, "fzf-lua")

local lspHighlightAugroup = vim.api.nvim_create_augroup("LspDocumentHighlight", {})

local function make_on_attach(_config)
  return function(client, bufnr)
    print("LSP "..client.name.." starting...")

    local opts = { noremap = true, silent = true }
    a.nvim_buf_set_keymap(bufnr, 'n', 'K',  '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    a.nvim_buf_set_keymap(bufnr, 'n', '<c-space>', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    a.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    a.nvim_buf_set_keymap(bufnr, 'n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    a.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)

    if hasFzf then
      a.nvim_buf_set_keymap(bufnr, 'n', '<leader>gr', '<cmd>FzfLua lsp_references<cr>', opts)
      a.nvim_buf_set_keymap(bufnr, 'n', '<leader>gs', '<cmd>FzfLua lsp_document_symbols()<cr>', opts)
      a.nvim_buf_set_keymap(bufnr, 'n', '<leader>gw', '<cmd>FzfLua lsp_workspace_symbols()<cr>', opts)
      a.nvim_buf_set_keymap(bufnr, 'n', '<leader>gi', '<cmd>FzfLua lsp_incoming_calls()<cr>', opts)
      a.nvim_buf_set_keymap(bufnr, 'n', '<leader>go', '<cmd>FzfLua lsp_outgoing_calls()<cr>', opts)
      a.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>FzfLua lsp_code_actions()<cr>', opts)
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
      if vim.bo.filetype ~= "elixir" or (vim.bo.filetype == "elixir" and client.name ~= "null-ls") then
        a.nvim_buf_create_user_command(bufnr, 'Format', function()
          local params = require('vim.lsp.util').make_formatting_params({})
          client.request("textDocument/formatting", params, nil, bufnr)
        end, { nargs = 0 })
      end
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

if not vim.g.disable_null_ls then
  null_ls.setup({
    on_attach = make_on_attach('null-ls'),
    sources = {
      null_ls.builtins.diagnostics.credo,
      null_ls.builtins.diagnostics.markdownlint,
      null_ls.builtins.formatting.sqlfluff.with({
        extra_args = {"--dialect", "postgres"},
      }),
      null_ls.builtins.diagnostics.sqlfluff.with({
        extra_args = {"--dialect", "postgres"},
      }),
      null_ls.builtins.diagnostics.erb_lint,
      null_ls.builtins.formatting.erb_lint,
      null_ls.builtins.diagnostics.write_good,
      null_ls.builtins.formatting.surface,
      null_ls.builtins.formatting.zigfmt,
      null_ls.builtins.diagnostics.shellcheck,
      null_ls.builtins.diagnostics.yamllint,
      null_ls.builtins.formatting.prettierd,
      null_ls.builtins.diagnostics.rubocop.with({
        command = function(_params)
          if vim.fn.glob("scripts/bin/rubocop-daemon/rubocop") ~= "" then
            return "scripts/bin/rubocop-daemon/rubocop"
          elseif os.execute("test -f Gemfile && grep 'gem .rubocop.' Gemfile") / 256 == 0 then
            return "bundle"
          else
            return "rubocop"
          end
        end,
        args = function(params)
          if params.cmd == "bundle" then
            return vim.list_extend({ "exec", "rubocop" }, null_ls.builtins.diagnostics.rubocop._opts.args)
          else
            return null_ls.builtins.diagnostics.rubocop._opts.args
          end
        end
      }),
      null_ls.builtins.formatting.eslint_d.with({
        cwd = function(params)
          return lspconfig.util.root_pattern(".eslintrc.js")(params.bufname)
        end
      }),
      null_ls.builtins.diagnostics.eslint_d.with({
        cwd = function(params)
          return lspconfig.util.root_pattern(".eslintrc.js")(params.bufname)
        end
      }),
      null_ls.builtins.code_actions.eslint_d.with({
        cwd = function(params)
          return lspconfig.util.root_pattern(".eslintrc.js")(params.bufname)
        end
      })
    }
  })
end

mason.setup()
mason_install.setup({
  ensure_installed = { "bashls", "cssls", "dockerls", "elixirls", "html",
    "jsonls", "shellcheck", "solargraph", "erb_lint", "sorbet", "rubocop",
    "sumneko_lua", "tailwindcss", "tsserver", "vimls", "vuels", "yamlls",
    "yamllint", "eslint_d", "prettierd", "write-good", "zls" }
})

local lsp_servers = {
  bashls = {},
  cssls = {},
  dockerls = {},
  elixirls = {},
  html = {
    filetypes = {"heex", "html", "eelixir", "eruby"}
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
  sqlls = {},
  sumneko_lua = {
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
local capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())

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
  'heex',
  'erb'
})
