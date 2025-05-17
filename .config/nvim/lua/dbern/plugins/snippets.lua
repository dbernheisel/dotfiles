local snip = require("luasnip")

-- Setup
snip.config.set_config({
  history = true,
  updateevents = "TextChanged,TextChangedI",
  enable_autosnippets = true
})

-- Snippets
snip.snippets = {
  all = {},
  lua = {
    snip.parser.parse_snippet("expand", "-- $1 this is $2 expanded$0"),
  },
  elixir = {
    snip.parser.parse_snippet("ins", "IO.inspect($1, label: \"$2\")$0"),
    snip.parser.parse_snippet("|>ins", "|> IO.inspect(label: \"$1\")$0"),
  },
}
