-- Test suite for reflow-markdown. Run with:
--   make test
-- or directly:
--   nvim --headless --noplugin -u tests/minimal_init.lua \
--     -c "lua MiniTest.run_file('tests/test_reflow.lua')"

local reflow = require('reflow-markdown').reflow
local eq = MiniTest.expect.equality

local T = MiniTest.new_set()

-- Tiny input/output helper: tests read cleaner when input/expected are
-- multi-line strings rather than manually-built tables of lines.
local function lines(s)
  -- Strip a single leading newline so heredoc-style literals look natural.
  s = s:gsub('^\n', '')
  local result = {}
  for line in (s .. '\n'):gmatch('([^\n]*)\n') do
    table.insert(result, line)
  end
  -- Drop a trailing empty element if the string ended with `\n`.
  if result[#result] == '' then result[#result] = nil end
  return result
end

local function assert_reflow(input, expected, opts)
  eq(reflow(lines(input), opts), lines(expected))
end

-- ─── Basic reflow ────────────────────────────────────────────────────

T['joins soft-wrapped paragraph lines'] = function()
  assert_reflow([[
Similar to validate/2 but returns the keyword
or raises an error.]],
    [[Similar to validate/2 but returns the keyword or raises an error.]])
end

T['preserves paragraph breaks across blank lines'] = function()
  assert_reflow([[
First paragraph
continues here.

Second paragraph
continues here.]],
    [[
First paragraph continues here.

Second paragraph continues here.]])
end

T['collapses multi-space continuation indent to single space'] = function()
  assert_reflow([[
Line one
    line two with leading spaces]],
    -- Leading 4+ spaces mark indented code and stop reflow. Use 2 spaces
    -- for a genuine continuation indent:
    [[
Line one
    line two with leading spaces]])
end

T['joins 2-space continuation indent as soft break'] = function()
  assert_reflow([[
Line one
  continuation]],
    [[Line one continuation]])
end

-- ─── Headings ────────────────────────────────────────────────────────

T['pad_headings injects blank line before heading after prose'] = function()
  assert_reflow([[
Some prose paragraph.
## Heading
More prose.]],
    [[
Some prose paragraph.

## Heading
More prose.]])
end

T['pad_headings = false disables heading padding'] = function()
  assert_reflow([[
Prose.
## Heading]],
    [[
Prose.
## Heading]],
    { pad_headings = false })
end

T['ATX heading is a hard boundary'] = function()
  -- pad_headings (default on) injects a blank *before* the heading
  -- when prev is prose; padding after the heading isn't done since
  -- CommonMark treats anything on the next line as a new block
  -- regardless, and renderers display it cleanly either way.
  assert_reflow([[
Before heading
# Heading
After heading]],
    [[
Before heading

# Heading
After heading]])
end

T['does not reflow into a heading'] = function()
  assert_reflow([[
## Examples
    iex> something]],
    [[
## Examples
    iex> something]])
end

-- ─── Lists ───────────────────────────────────────────────────────────

T['bullet list items are block starts'] = function()
  assert_reflow([[
- item one
- item two
- item three]],
    [[
- item one
- item two
- item three]])
end

T['lazy continuation reflows into the list item'] = function()
  -- CommonMark: a non-indented continuation line belongs to the current
  -- list item.
  assert_reflow([[
- list item that wraps
  across two lines
- next item]],
    [[
- list item that wraps across two lines
- next item]])
end

T['ordered list items are block starts'] = function()
  assert_reflow([[
1. first
2. second]],
    [[
1. first
2. second]])
end

-- ─── Code fences ─────────────────────────────────────────────────────

T['fenced code block preserves multi-line content'] = function()
  assert_reflow([[
```elixir
@spec validate!(
  keyword(),
  values :: [atom() | {atom(), term()}]
) :: keyword()
```]],
    [[
```elixir
@spec validate!(
  keyword(),
  values :: [atom() | {atom(), term()}]
) :: keyword()
```]])
end

T['pad_fences does not inject blank line after closing fence'] = function()
  -- Closing fences don't get trailing padding — markview conceals the
  -- ``` line, so an injected blank would appear as a double gap.
  assert_reflow([[
```elixir
code
```
Prose right after fence.]],
    [[
```elixir
code
```
Prose right after fence.]])
end

T['pad_fences injects blank line before opening fence'] = function()
  assert_reflow([[
Prose immediately before.
```elixir
code
```]],
    [[
Prose immediately before.

```elixir
code
```]])
end

T['pad_fences = false leaves fences un-padded'] = function()
  assert_reflow([[
Prose.
```
code
```
More prose.]],
    [[
Prose.
```
code
```
More prose.]],
    { pad_fences = false })
end

-- ─── Hard line breaks ────────────────────────────────────────────────

T['trailing two-space is a hard break'] = function()
  assert_reflow(
    'Line ending in two spaces.  \nSecond line stays separate.',
    'Line ending in two spaces.  \nSecond line stays separate.')
end

T['trailing backslash is a hard break'] = function()
  assert_reflow([[
Line ending in backslash.\
Second line stays separate.]],
    [[
Line ending in backslash.\
Second line stays separate.]])
end

-- ─── Tables and rules ────────────────────────────────────────────────

T['table rows are not reflowed'] = function()
  assert_reflow([[
| a | b |
| - | - |
| 1 | 2 |]],
    [[
| a | b |
| - | - |
| 1 | 2 |]])
end

T['horizontal rule is a block boundary'] = function()
  assert_reflow([[
Above rule.

---

Below rule.]],
    [[
Above rule.

---

Below rule.]])
end

-- ─── Blockquotes ─────────────────────────────────────────────────────

T['blockquotes are block starts'] = function()
  assert_reflow([[
Regular prose.
> quoted line one
> quoted line two]],
    [[
Regular prose.
> quoted line one
> quoted line two]])
end

-- ─── Indented code ───────────────────────────────────────────────────

T['4-space indent is preserved as code'] = function()
  assert_reflow([[
Prose above.

    iex> Keyword.validate!([], [])
    []
    iex> next example]],
    [[
Prose above.

    iex> Keyword.validate!([], [])
    []
    iex> next example]])
end

-- ─── Compact pass ────────────────────────────────────────────────────

T['compacts blanks between same-shape bold entries'] = function()
  assert_reflow([[
**Key one:** value

**Key two:** value

**Key three:** value]],
    [[
**Key one:** value
**Key two:** value
**Key three:** value]])
end

T['compacts blanks between same-shape list items'] = function()
  assert_reflow([[
- item one

- item two]],
    [[
- item one
- item two]])
end

T['keeps blank before plain prose paragraph'] = function()
  assert_reflow([[
**Key:** value

Regular prose follows.]],
    [[
**Key:** value

Regular prose follows.]])
end

T['compact_same_shapes = false disables compaction'] = function()
  assert_reflow([[
**Key one:** value

**Key two:** value]],
    [[
**Key one:** value

**Key two:** value]],
    { compact_same_shapes = false })
end

-- ─── Input handling ──────────────────────────────────────────────────

T['handles embedded newlines in a single chunk'] = function()
  -- Some LSPs pass `contents` as a single long string.
  eq(reflow({ 'Line one\nLine two\n\nSecond para' }),
     { 'Line one Line two', '', 'Second para' })
end

T['empty input returns empty'] = function()
  eq(reflow({}), {})
end

T['single line passes through'] = function()
  eq(reflow({ 'hello' }), { 'hello' })
end

-- ─── fence_indented_code ────────────────────────────────────────────

T['fence_indented_code wraps indented blocks in fenced language blocks'] = function()
  assert_reflow([[
Prose before.

    stdout_sink = Runcom.Sink.DETS.new(path: "/tmp/x.dets")
    result.exit_code

Prose after.]],
    [[
Prose before.

```elixir
stdout_sink = Runcom.Sink.DETS.new(path: "/tmp/x.dets")
result.exit_code
```
Prose after.]],
    { fence_indented_code = 'elixir' })
end

T['fence_indented_code preserves internal blank lines inside code'] = function()
  assert_reflow([[
Prose.

    line one
    line two

    line three

Prose after.]],
    [[
Prose.

```elixir
line one
line two

line three
```
Prose after.]],
    { fence_indented_code = 'elixir' })
end

T['fence_indented_code does not wrap indent following prose'] = function()
  -- CommonMark indented code blocks require a preceding blank line. A
  -- 4-space-indented line directly after prose is *not* a code block,
  -- so pass_fence_indented must leave it alone (no fence wrap). Note
  -- that our reflow pass conservatively also declines to join these
  -- into the prose — tracked by `4-space indent` being a block start.
  assert_reflow([[
A paragraph and its
    continuation line.]],
    [[
A paragraph and its
    continuation line.]],
    { fence_indented_code = 'elixir' })
end

T['fence_indented_code leaves existing fenced blocks alone'] = function()
  assert_reflow([[
```python
already_fenced = True
```

    indented_block()]],
    [[
```python
already_fenced = True
```

```elixir
indented_block()
```]],
    { fence_indented_code = 'elixir' })
end

T['fence_indented_code wraps indented block directly after a heading'] = function()
  -- CommonMark allows indented code immediately after a heading (no
  -- blank line required) because headings close their own block. Expert
  -- relies on this in `## Examples\n    iex> …`.
  assert_reflow([=[
## Examples
    iex> Keyword.put([a: 1], :b, 2)
    [b: 2, a: 1]]=],
    [=[
## Examples

```elixir
iex> Keyword.put([a: 1], :b, 2)
[b: 2, a: 1]
```]=],
    { fence_indented_code = 'elixir' })
end

T['fence_indented_code = false (default) is a no-op'] = function()
  assert_reflow([[
Prose.

    code_here
    more_code]],
    [[
Prose.

    code_here
    more_code]])
end

-- ─── Integration: full ElixirLS-style hover ──────────────────────────

T['full Elixir hover renders cleanly'] = function()
  -- Note: using [=[ ]=] brackets because the Elixir `[one: 1, two: 2]`
  -- contains `]` characters that would otherwise collide with `]]`.
  assert_reflow([=[
## Keyword.validate!(keyword, values)

```elixir
@spec validate!(
  keyword(),
  values :: [atom() | {atom(), term()}]
) :: keyword()
```
Similar to `validate/2` but returns the keyword or
raises an error.

## Examples

    iex> Keyword.validate!([], [one: 1, two: 2]) |> Enum.sort()
    [one: 1, two: 2]]=],
    [=[
## Keyword.validate!(keyword, values)

```elixir
@spec validate!(
  keyword(),
  values :: [atom() | {atom(), term()}]
) :: keyword()
```
Similar to `validate/2` but returns the keyword or raises an error.

## Examples

    iex> Keyword.validate!([], [one: 1, two: 2]) |> Enum.sort()
    [one: 1, two: 2]]=])
end

-- ─── Admonitions ────────────────────────────────────────────────────

T['admonitions'] = MiniTest.new_set()

T['admonitions']['rewrites error admonition to GitHub alert'] = function()
  assert_reflow([[
> #### Error {: .error}
>
> This is an error]], [[
> [!ERROR]
>
> This is an error]])
end

T['admonitions']['rewrites warning admonition'] = function()
  assert_reflow([[
> #### Warning {: .warning}
>
> Be careful]], [[
> [!WARNING]
>
> Be careful]])
end

T['admonitions']['rewrites info admonition'] = function()
  assert_reflow([[
> #### Info {: .info}
>
> Some info]], [[
> [!INFO]
>
> Some info]])
end

T['admonitions']['rewrites tip admonition'] = function()
  assert_reflow([[
> #### Tip {: .tip}
>
> A helpful tip]], [[
> [!TIP]
>
> A helpful tip]])
end

T['admonitions']['rewrites neutral admonition to QUOTE'] = function()
  assert_reflow([[
> #### Neutral {: .neutral}
>
> Neutral text]], [[
> [!QUOTE]
>
> Neutral text]])
end

T['admonitions']['preserves custom title when different from type'] = function()
  assert_reflow([[
> #### Watch out! {: .warning}
>
> Something dangerous]], [[
> [!WARNING] Watch out!
>
> Something dangerous]])
end

T['admonitions']['works with any heading level'] = function()
  assert_reflow([[
> ## Big Error {: .error}
>
> Body]], [[
> [!ERROR] Big Error
>
> Body]])
end

T['admonitions']['ignores unknown classes'] = function()
  assert_reflow([[
> #### Custom {: .custom}
>
> Body]], [[
> #### Custom {: .custom}
>
> Body]])
end

T['admonitions']['strips tabs-open and tabs-close comments'] = function()
  assert_reflow([[
Some text

<!-- tabs-open -->

## Tab One

Content here

<!-- tabs-close -->

More text]], [[
Some text

## Tab One

Content here

More text]])
end

T['admonitions']['strips tabs comments surrounded by blank lines'] = function()
  assert_reflow([[
Above

<!-- tabs-open -->

Below]], [[
Above

Below]])
end

T['admonitions']['ignores non-blockquote lines with IAL'] = function()
  -- The pattern requires a `> ` prefix — bare headings with IAL pass through
  assert_reflow([[
#### Error {: .error}

Body text]], [[
#### Error {: .error}

Body text]])
end

-- ─── ExDoc auto-link stripping ────────────────────────────────────────

T['exdoc autolinks'] = MiniTest.new_set()

local exdoc_opts = { strip_exdoc_autolinks = true }

T['exdoc autolinks']['strips m: prefix from module links'] = function()
  assert_reflow(
    'See `m:MyModule` for details.',
    'See `MyModule` for details.',
    exdoc_opts)
end

T['exdoc autolinks']['strips t: prefix from type links'] = function()
  assert_reflow(
    'Returns `t:MyModule.t()`.',
    'Returns `MyModule.t()`.',
    exdoc_opts)
end

T['exdoc autolinks']['strips c: prefix from callback links'] = function()
  assert_reflow(
    'Implements `c:GenServer.init/1`.',
    'Implements `GenServer.init/1`.',
    exdoc_opts)
end

T['exdoc autolinks']['strips multiple prefixes on one line'] = function()
  assert_reflow(
    'Uses `m:Foo` and `t:Foo.bar()` and `c:Foo.baz/2`.',
    'Uses `Foo` and `Foo.bar()` and `Foo.baz/2`.',
    exdoc_opts)
end

T['exdoc autolinks']['does not strip inside fenced code blocks'] = function()
  assert_reflow([[
```elixir
`m:MyModule`
```]], [[
```elixir
`m:MyModule`
```]], exdoc_opts)
end

T['exdoc autolinks']['disabled by default'] = function()
  assert_reflow(
    'See `m:MyModule` for details.',
    'See `m:MyModule` for details.')
end

return T
