local a = vim.api
local lsputil = require("vim.lsp.util")
local hasFzf, _Fzf = pcall(require, "fzf-lua")
local osInfo = vim.uv.os_uname()
local homedir = vim.uv.os_homedir()
local expert = vim.fn.resolve(homedir.."/.local/bin/" .."expert_"..string.lower(osInfo.sysname).."_"..string.lower(osInfo.machine))
print(expert)

local M = {}

M.servers = {
  bashls = {
    filetypes = {"sh", "bash", "zsh"},
    settings = {
      bashIde = {
        globPattern = "*@(.sh|.inc|.bash|.command|.zsh|zshrc|zsh_*)"
      }
    }
  },
  cssls = {},
  dockerls = {},
  expert = {
    cmd = { expert },
    root_markers = {'mix.exs', '.git'},
    filetypes = { "elixir", "eelixir", "heex" },
  },
  html = {},
  jsonls = {},
  kotlin_language_server = {},
  lua_ls = {},
  markdown_oxide = {
    capabilities = {
      workspace = {
        didChangeWatchedFiles = {
          dynamicRegistration = true
        }
      }
    }
  },
  pylsp = {},
  -- "ruby_lsp",
  sourcekit = {},
  sqlls = {},
  tailwindcss = {},
  ts_ls = {},
  vimls = {},
  vuels = {},
  yamlls = {},
  zls = {},
}

M.on_attach = function(args)
  local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
  local bufnr = args.buf

  if client.name == "ElixirLS" then
    vim.keymap.set("n", "<space>fp", ":ElixirFromPipe<cr>", { buffer = true, noremap = true })
    vim.keymap.set("n", "<space>tp", ":ElixirToPipe<cr>", { buffer = true, noremap = true })
    vim.keymap.set("v", "<space>em", ":ElixirExpandMacro<cr>", { buffer = true, noremap = true })
  end

  local kmp = function(lhs, rhs, desc)
    a.nvim_buf_set_keymap(bufnr, 'n', lhs, rhs, { noremap = true, silent = true, desc = desc })
  end

  kmp('K', '<cmd>lua vim.lsp.buf.hover()<cr>', "Show help")
  kmp('<c-space>', '<cmd>lua vim.lsp.buf.signature_help()<cr>', "Show signature help")
  if _G.Snacks then
    kmp('gd', '<cmd>lua Snacks.picker.lsp_definitions()<cr>', "Goto definition")
    kmp('gt', '<cmd>lua Snacks.picker.lsp_type_definitions()<cr>', "Goto type definition")
    kmp('gi', '<cmd>lua Snacks.picker.lsp_implementations()<cr>', "Goto implementation")
    kmp('<leader>gr', '<cmd>lua Snacks.picker.lsp_references()<cr>', "References")
    kmp('<leader>gs', '<cmd>lua Snacks.picker.lsp_symbols()<cr>', "Document Symbols")
    kmp('<leader>gw', '<cmd>lua Snacks.picker.lsp_workspace_symbols()<cr>', "Workspace symbols")
    if hasFzf then
      kmp('<leader>gi', '<cmd>FzfLua lsp_incoming_calls<cr>', "Incoming calls")
      kmp('<leader>go', '<cmd>FzfLua lsp_outgoing_calls<cr>', "Outgoing calls")
    end
  elseif hasFzf then
    kmp('gd', '<cmd>lua <cmd>FzfLua lsp_definitions()<cr>', "Goto definition")
    kmp('gt', '<cmd>lua <cmd>FzfLua lsp_typedefs()<cr>', "Goto type definition")
    kmp('gi', '<cmd>lua <cmd>FzfLua lsp_implementations()<cr>', "Goto implementation")
    kmp('<leader>gr', '<cmd>FzfLua lsp_references<cr>', "References")
    kmp('<leader>gs', '<cmd>FzfLua lsp_document_symbols<cr>', "Document Symbols")
    kmp('<leader>gw', '<cmd>FzfLua lsp_workspace_symbols<cr>', "Workspace symbols")
    kmp('<leader>gi', '<cmd>FzfLua lsp_incoming_calls<cr>', "Incoming calls")
    kmp('<leader>go', '<cmd>FzfLua lsp_outgoing_calls<cr>', "Outgoing calls")
  else
    kmp('<leader>gr', '<cmd>lua vim.lsp.buf.references()<cr>', "LSP References")
    kmp('<leader>gs', '<cmd>lua vim.lsp.buf.document_symbol()<cr>', "Document Symbols")
    kmp('<leader>gw', '<cmd>lua vim.lsp.buf.workspace_symbol()<cr>', "Workspace symbols")
    kmp('<leader>gi', '<cmd>lua vim.lsp.buf.incoming_calls()<cr>', "Incoming calls")
    kmp('<leader>go', '<cmd>lua vim.lsp.buf.outgoing_calls()<cr>', "Outgoing calls")
  end

  kmp('<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', "Code actions")

  if client:supports_method("textDocument/rename") then
    kmp('<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', "Rename")
  end

  if client:supports_method('textDocument/foldingRange') then
    local win = vim.api.nvim_get_current_win()
    vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
  end

  if client:supports_method("textDocument/formatting") then
    a.nvim_buf_create_user_command(bufnr, 'Format', function()
      client:request("textDocument/formatting", lsputil.make_formatting_params(), nil, bufnr)
    end, { nargs = 0 })
  end

  -- Highlight
  if client:supports_method("textDocument/documentHighlight") then
    a.nvim_clear_autocmds({ group = M.lspHighlightAugroup, buffer = bufnr })
    a.nvim_create_autocmd("CursorHold", {
      group = M.lspHighlightAugroup,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.document_highlight()
      end,
    })
    a.nvim_create_autocmd("CursorMoved", {
      group = M.lspHighlightAugroup,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.clear_references()
      end,
    })
  end

  a.nvim_command('setlocal omnifunc=v:lua.vim.lsp.omnifunc')
end

---@param args vim.api.keyset.create_autocmd.callback_args
M.on_detach = function(args)
  local client = vim.lsp.get_client_by_id(args.data.client_id)
  if not client or not client.attached_buffers then return end
  for buf_id in pairs(client.attached_buffers) do
    if buf_id ~= args.buf then return end
  end
  client:stop()
end

M.setup = function()
  M.lspHighlightAugroup = vim.api.nvim_create_augroup("LspDocumentHighlight", {})

  a.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('my.lsp.attach', {}),
    callback = M.on_attach,
    desc = "Start LSP clients"
  })

  a.nvim_create_autocmd("LspDetach", {
    group = vim.api.nvim_create_augroup("my.lsp.detact", {}),
    callback = M.on_detach,
    desc = "Stop LSP client when no buffer is attached",
  })

  require('lspconfig')

  -- :Mason
  require('mason').setup()
  require('mason-lspconfig').setup({
    automatic_enable = true,
    automatic_installation = false,
    ensure_installed = { "bashls", "cssls", "dockerls", "html", "jsonls", "markdown_oxide",
      "solargraph", "kotlin_language_server", "lua_ls", "tailwindcss", "ts_ls", "vimls",
      "vuels", "ruby_lsp", "sqlls", "yamlls", "zls" }
  })

  for server, server_config in pairs(M.servers) do
    if vim.tbl_count(server_config) ~= 0 then
      vim.lsp.config(server, server_config)
    end
    vim.lsp.enable(server)
  end

  require('colorizer').setup({'css', 'scss', 'sass', 'javascript', 'html',
    'svg', 'lua', 'vim', 'svg', 'conf', 'eelixir', 'elixir', 'heex', 'erb'})
end

return M
