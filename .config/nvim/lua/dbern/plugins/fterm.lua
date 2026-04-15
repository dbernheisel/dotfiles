local fterm = require('FTerm')

local M = {}

local test_terminal = fterm:new({
  blend = 2,
  border = 'rounded',
  hl = 'FTerm',
  dimensions = { height = 0.9, width = 0.9 }
})

local gen_terminal = fterm:new({
  blend = 2,
  border = 'rounded',
  hl = 'FTerm',
  dimensions = { height = 0.9, width = 0.9 }
})

M.toggle_term = function()
  test_terminal:close()
  gen_terminal:toggle()
end

M.toggle_test = function()
  gen_terminal:close()
  test_terminal:toggle()
end

M.run_cmd = function(cmd)
  gen_terminal:close()
  local cancel_command = vim.api.nvim_replace_termcodes("<C-u>", true, false, true)
  test_terminal:run(cancel_command)
  test_terminal:run(cmd)
end

_G.toggle_test = M.toggle_test
_G.toggle_term = M.toggle_term
_G.run_cmd = M.run_cmd

M.setup = function()
  local opts = { noremap = true, silent = true }
  vim.api.nvim_set_keymap('n', '<leader>t1', ':call v:lua.toggle_term()<cr>', opts)
  vim.api.nvim_set_keymap('n', '<leader>t2', ':call v:lua.toggle_test()<cr>', opts)
  vim.api.nvim_set_keymap('t', '<leader>t1', '<c-\\><c-n>:call v:lua.toggle_term()<cr><esc>', opts)
  vim.api.nvim_set_keymap('t', '<leader>t2', '<c-\\><c-n>:call v:lua.toggle_test()<cr><esc>', opts)

  local function set_fterm_hl()
    vim.api.nvim_set_hl(0, 'FTerm', { bg = '#151515' })
  end
  set_fterm_hl()

  local group = vim.api.nvim_create_augroup('fterm-float-bg', {})
  vim.api.nvim_create_autocmd('ColorScheme', {
    group = group,
    callback = set_fterm_hl,
  })
  vim.api.nvim_create_autocmd('FileType', {
    group = group,
    pattern = 'FTerm',
    callback = function()
      vim.api.nvim_set_option_value('winhl', 'Normal:FTerm,NormalFloat:FTerm', { win = 0 })
    end,
  })
end

-- Keymaps
return M
