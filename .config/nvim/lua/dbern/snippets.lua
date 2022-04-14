local ls = require("luasnip")

-- Setup
ls.config.set_config({
  history = true,
  updateevents = "TextChanged,TextChangedI",
  enable_autosnippets = true
})

-- Keymaps
-- if vim.fn.has('nvim-0.7') then
--   vim.keymap.set({"i", "s"}, "<c-k>", function()
--     if ls.expand_or_jumpable() then
--       ls.expand_or_jump()
--     end
--   end, { silent = true })
--
--   vim.keymap.set({"i", "s"}, "<c-j>", function()
--     if ls.jumpable(-1) then
--       ls.jump(-1)
--     end
--   end, { silent = true })
--
--   vim.keymap.set({"i", "s"}, "<c-l>", function()
--     if ls.choice_active() then
--       ls.change_choice(1)
--     end
--   end, { silent = true })
--
--   vim.keymap.set("n", "<leader><leader>s", "<cmd>source ~/.config/nvim/lua/dbern/snippets.lua<CR>")
-- end

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

local M = {}

M.expand_or_jump = function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end

M.jump_back = function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end

M.change_snippet = function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end

return M
