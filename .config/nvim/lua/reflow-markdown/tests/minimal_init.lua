-- Minimal init for running the test suite against a freshly-bootstrapped
-- Neovim. Clones mini.nvim into a local cache on first run, then sets up
-- MiniTest. Contributors only need `nvim` on PATH — no global plugin
-- install required.

local cache = vim.fn.stdpath('cache') .. '/reflow-markdown-test-deps'
local mini_path = cache .. '/mini.nvim'

if vim.fn.isdirectory(mini_path) == 0 then
  vim.fn.mkdir(cache, 'p')
  print('Cloning mini.nvim into ' .. mini_path)
  vim.fn.system({
    'git', 'clone', '--depth=1', '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim', mini_path,
  })
end

-- Make mini.nvim importable.
vim.opt.rtp:prepend(mini_path)

-- Make the plugin-under-test importable. This init currently lives at
-- `lua/reflow-markdown/tests/minimal_init.lua` inside a larger Neovim
-- config. To expose `require('reflow-markdown')` we prepend the dir
-- whose `lua/` contains the module — three levels up from this file.
-- When the plugin is extracted to a standalone repo (see README), the
-- layout changes to `tests/minimal_init.lua` + `lua/reflow-markdown/`
-- at the repo root, and this becomes `:h:h` (two up).
local this_dir = vim.fn.fnamemodify(debug.getinfo(1, 'S').source:sub(2), ':p:h')
local rtp_root = vim.fn.fnamemodify(this_dir, ':h:h:h')
vim.opt.rtp:prepend(rtp_root)

local MT = require('mini.test')
MT.setup({
  -- Use the plain-text stdout reporter so headless/CI output is readable.
  execute = {
    reporter = MT.gen_reporter.stdout({ group_depth = 1 }),
    stop_on_error = false,
  },
})
