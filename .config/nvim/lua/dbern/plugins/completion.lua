local cmp = require('cmp')
local luasnip = require('luasnip')
local lspkind = require('lspkind')
local context = require("cmp.config.context")
local tailwind_tools = require("tailwind-tools.cmp")
-- require('dbern.gh_issues')
-- require('dbern.plugins.cmp-hex')

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
  formatting = {
    format = lspkind.cmp_format({
      before = tailwind_tools.lspkind_format
    }),
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  enable = function()
    return not (
      context.in_treesitter_capture("comment") or context.in_syntax_group("Comment")
    )
  end ,
  mapping = cmp.mapping.preset.insert({
    ['<c-d>'] = cmp.mapping.scroll_docs(-4),
    ['<c-f>'] = cmp.mapping.scroll_docs(4),
    ['<c-space>'] = cmp.mapping.complete(),
    -- ['<c-e>'] = cmp.mapping({cmp.mapping.abort(), cmp.mapping.close()}),
    ['<c-y>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
    ['<cr>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { 'i', 's', 'c' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's', 'c' }),
  }),
  window = {
    documentation = cmp.config.window.bordered(),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp_signature_help' },
  }, {
    { name = 'path' },
  }, {
    { name = 'nvim_lsp' ,
      option = {
        markdown_oxide = {
          keyword_pattern = [[\(\k\| \|\/\|#\)\+]]
        }
      }
    },
  }, {
    { name = 'calc' },
    { name = 'luasnip' },
    -- { name = 'hex', keyword_length = 3 },
    { name = 'npm', keyword_length = 4 },
    { name = 'treesitter' },
  }, {
    { name = 'buffer', keyword_length = 5, max_item_count = 5 },
  })
})

cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  completion = {
    keyword_pattern = [=[[^[:blank:]].*]=]
  },
  sources = {
    { name = 'nvim_lsp_document_symbol' },
    { name = 'buffer' },
  },
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  completion = { autocomplete = false },
  sources = cmp.config.sources({
    { name = 'path' },
  }, {
    { name = 'cmdline' }
  }),
})

cmp.setup.filetype({ 'markdown', 'help' }, {
  window = {
    documentation = cmp.config.disable
  }
})

cmp.setup.filetype({ 'gitcommit' }, {
  sources = cmp.config.sources({
    -- { name = 'gh_issues' },
  }),
})
