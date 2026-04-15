# reflow-markdown.nvim

Reflow soft-wrapped markdown in LSP hover popups so paragraphs render
cleanly, matching CommonMark / VS Code behavior.

## Why

Neovim's LSP hover pipeline passes `contents` straight through to the
float buffer without applying CommonMark's rule that a single `\n`
within a paragraph is a soft break (rendered as a space). LSP servers
like `rust-analyzer`, `elixir-ls`, and `gopls` hard-wrap doc text at
~80 columns, so hovers look ragged.

Decorator plugins (`render-markdown.nvim`, `markview.nvim`) cannot
fix this — they only paint extmarks over existing lines. The correct
choke-point is the line list *before* it's written to the float
buffer. This plugin monkey-patches `vim.lsp.util.open_floating_preview`
at that layer.

## Install

### lazy.nvim

```lua
{
  'YOU/reflow-markdown.nvim',
  event = 'LspAttach',
  config = function()
    require('reflow-markdown').setup()
  end,
}
```

### Manual

Drop `lua/reflow-markdown/init.lua` into your runtimepath's `lua/`
directory and call `require('reflow-markdown').setup()` from your init.

## Usage

```lua
require('reflow-markdown').setup()
-- or, with options:
require('reflow-markdown').setup({
  pad_fences = true,           -- blank lines around ``` fences (default: true)
  compact_same_shapes = true,  -- collapse blanks between same-shape entries
  max_width = 80,              -- cap hover float width; false to defer to nvim
  wrap = true,                 -- soft-wrap long lines inside the hover
  lsp_hover = true,            -- install the LSP hover patch (default: true)
})
```

For ad-hoc use on any markdown source:

```lua
local reflow = require('reflow-markdown').reflow
local out = reflow({ 'Line one', 'line two', '', 'Paragraph two.' })
-- → { 'Line one line two', '', 'Paragraph two.' }
```

## What it preserves

- Fenced code blocks (` ```lang ... ``` `): interior passes through untouched
- Indented code blocks (4-space / tab)
- ATX headings (`# Heading`)
- Tables (pipe rows)
- Horizontal rules (`---`, `***`, `___`)
- Hard line breaks (trailing `"  "` or `\`)
- Blockquotes (`> …`)
- List items (with CommonMark lazy continuation into the item)

## What it changes

- **Joins** consecutive prose lines within a paragraph (the core reflow)
- **Pads** blank lines around fenced code blocks so renderers can
  cleanly conceal the fence markers
- **Compacts** blank-line runs between consecutive same-shape entries
  (e.g. `**Key:** val` pairs stack tightly; `[Link](url)` lists stack
  tightly; different shapes keep one blank separator)

## Tests

```sh
make test
```

On first run this clones `mini.nvim` into Neovim's cache dir (for the
`mini.test` harness). Subsequent runs are offline. Wipe the cache with
`make clean-deps`.

Run a single file:

```sh
make test-file FILE=tests/test_reflow.lua
```

## Layout

Inside an existing Neovim config (vendored form):

```
lua/reflow-markdown/
├── init.lua
├── tests/
│   ├── minimal_init.lua
│   └── test_reflow.lua
├── Makefile
└── README.md
```

As a standalone repository, restructure to:

```
reflow-markdown.nvim/
├── lua/
│   └── reflow-markdown/
│       └── init.lua
├── tests/
│   ├── minimal_init.lua
│   └── test_reflow.lua
├── Makefile
└── README.md
```

And change `rtp_root` in `tests/minimal_init.lua` from `:h:h:h` to
`:h:h` (two levels up instead of three).

## Design notes

- **Two-pass algorithm**: first pass joins soft-wrapped paragraph lines
  and pads fence transitions; second pass compacts blank-line runs
  between same-shape entries.
- **Block boundary detection**: follows CommonMark's rules for what
  opens/closes a block. List items and blockquote markers are block
  starts but not block ends — that's how lazy continuation works.
- **Idempotent patching**: `patch_lsp_hover()` is safe to call multiple
  times; it wraps `open_floating_preview` only once.
- **Pure core**: `reflow(lines, opts)` has no side effects — safe to
  use outside the LSP path (file contents, test fixtures, pasted text).
