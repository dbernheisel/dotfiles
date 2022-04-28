local spectre = require('spectre')

_G.sr_find = function()
  spectre.open()
end

_G.sr_find_word = function()
  spectre.open_visual()
end

_G.sr_find_in_buffer = function()
  spectre.open_file_search()
end

local M = {}
M.setup = function()
  spectre.setup()

  vim.api.nvim_set_keymap('n', '<leader>sr', 'call v:lua.sr_find()<cr>', { noremap = true })

  -- search current word
  vim.api.nvim_set_keymap('n', '<leader>srw', 'call v:lua.sr_find_word()<cr>', { noremap = true })
  vim.api.nvim_set_keymap('v', '<leader>srw', 'call v:lua.sr_find_word()<cr>', { noremap = true })

  -- search in current file
  vim.api.nvim_set_keymap('n', '<leader>sp', 'call v:lua.sr_find_in_buffer()<cr>', { noremap = true })
end
return M
