local spectre = require('spectre')
spectre.setup()

local M = {}

M.find = function()
  spectre.open()
end

M.find_word = function()
  spectre.open_visual()
end


M.find_in_buffer = function()
  spectre.open_file_search()
end

return M
