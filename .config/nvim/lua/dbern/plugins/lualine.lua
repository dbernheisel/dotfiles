local U = require('dbern.utils')
require('lualine').setup({
  options = {
    globalstatus = U.has('nvim-0.7'),
    theme = 'sonokai',
  },
})
