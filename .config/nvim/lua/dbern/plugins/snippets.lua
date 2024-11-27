local ls = require("luasnip")

-- _G.expand_or_jump = function()
--   if ls.expand_or_jumpable() then
--     ls.expand_or_jump()
--   end
-- end
--
-- _G.jump_back = function()
--   if ls.jumpable(-1) then
--     ls.jump(-1)
--   end
-- end
--
-- _G.change_snippet = function()
--   if ls.choice_active() then
--     ls.change_choice(1)
--   end
-- end
--
-- vim.api.nvim_set_keymap('i', '<c-k>', ':call v:lua.expand_or_jump()<cr>', { noremap = true })
-- vim.api.nvim_set_keymap('s', '<c-k>', ':call v:lua.expand_or_jump()<cr>', { noremap = true })
--
-- vim.api.nvim_set_keymap('i', '<c-j>', ':call v:lua.jump_back()<cr>', { noremap = true })
-- vim.api.nvim_set_keymap('s', '<c-j>', ':call v:lua.jump_back()<cr>', { noremap = true })
--
-- vim.api.nvim_set_keymap('i', '<c-l>', ':call v:lua.change_snippet()<cr>', { noremap = true })
-- vim.api.nvim_set_keymap('s', '<c-l>', ':call v:lua.change_snippet()<cr>', { noremap = true })
-- vim.api.nvim_set_keymap("n", "<leader><leader>s", "<cmd>source ~/.config/nvim/lua/dbern/snippets.lua<CR>")

-- Setup
ls.config.set_config({
  history = true,
  updateevents = "TextChanged,TextChangedI",
  enable_autosnippets = true
})

-- Snippets
ls.snippets = {
  all = {},
  lua = {
    ls.parser.parse_snippet("expand", "-- $1 this is $2 expanded$0"),
  },
  elixir = {
    ls.parser.parse_snippet("ins", "IO.inspect($1, label: \"$2\")$0"),
    ls.parser.parse_snippet("|>ins", "|> IO.inspect(label: \"$1\")$0"),
  },
}
