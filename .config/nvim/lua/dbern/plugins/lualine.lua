local U = require('dbern.utils')
local lualine = require('lualine')
local trouble = require('trouble')

local opts = {
  options = {
    globalstatus = U.has('nvim-0.7'),
    theme = 'moonfly',
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {},
    lualine_y = {'encoding', 'fileformat', 'filetype'},
    lualine_z = {'location'}
  },
}

vim.api.nvim_create_augroup("lualine_augroup", { clear = true })

local symbols = trouble.statusline({
  mode = "lsp_document_symbols",
  groups = {},
  title = false,
  filter = { range = true },
  format = "{kind_icon}{symbol.name:Normal}",
  -- The following line is needed to fix the background color
  -- Set it to the lualine section you want to use
  hl_group = "lualine_c_normal",
})

table.insert(opts.sections.lualine_c, {
  symbols.get,
  cond = symbols.has,
})

lualine.setup(opts)
