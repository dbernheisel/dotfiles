" Highlight character that marks where line is too long
setlocal textwidth=120
setlocal colorcolumn=+1

" Only needed for older Elixir Umbrella projects:
" function! ElixirUmbrellaTransform(cmd) abort
"   if match(a:cmd, 'apps/') != -1
"     return substitute(a:cmd, 'mix test apps/\([^/]*\)/', 'mix cmd --app \1 mix test --color ', '')
"   else
"     return a:cmd
"   end
" endfunction
"
" let g:test#custom_transformations = {'elixir_umbrella': function('ElixirUmbrellaTransform')}
" let g:test#transformation = 'elixir_umbrella'

let g:projectionist_heuristics['mix.exs'] = {
  \ 'apps/*/mix.exs': { 'type': 'app' },
  \ 'lib/*.ex': {
  \   'type': 'lib',
  \   'alternate': 'test/{}_test.exs',
  \   'template': [
  \     'defmodule {camelcase|capitalize|dot} do',
  \     'end'
  \   ],
  \ },
  \ 'test/*_test.exs': {
  \   'type': 'test',
  \   'alternate': 'lib/{}.ex',
  \   'template': [
  \     'defmodule {camelcase|capitalize|dot}Test do',
  \     '  use ExUnit.Case, async: true',
  \     '',
  \     '  alias {camelcase|capitalize|dot}',
  \     '',
  \     'end'
  \   ],
  \ },
  \ 'mix.exs': { 'type': 'mix' },
  \ 'config/*.exs': { 'type': 'config' },
  \ '*.ex': {
  \   'makery': {
  \     'lint': { 'compiler': 'credo' },
  \     'test': { 'compiler': 'exunit' },
  \     'build': { 'compiler': 'mix' }
  \   }
  \ },
  \ '*.exs': {
  \   'makery': {
  \     'lint': { 'compiler': 'credo' },
  \     'test': { 'compiler': 'exunit' },
  \     'build': { 'compiler': 'mix' }
  \   }
  \ }
  \ }
