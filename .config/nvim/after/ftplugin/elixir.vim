" Highlight character that marks where line is too long
setlocal textwidth=120
setlocal colorcolumn=+1

function! g:MixRun(selection) abort
  if !empty(a:selection)
    execute "!mix ".a:selection
  endif
endfunction

function! g:MixFzf(selection = '') abort
  if empty(a:selection)
    call fzf#run(fzf#wrap({
      \ 'source': 'mix help --names',
      \ 'sink': function('g:MixRun'),
      \ 'layout' : {
        \ 'window': {
          \ 'width': 0.95,
          \ 'height': 0.9,
          \ 'relative': v:true,
          \ 'yoffset': 1.0 } },
      \ 'options': "--preview 'mix help {}'"}))
  else
    call MixRun(a:selection)
  endif
endfunction

command! -nargs=* Mix call MixFzf(<q-args>)

augroup _elixir
  autocmd BufNewFile,BufRead *.html.eex,*.html.leex,*.heex set filetype=heex
  autocmd BufNewFile,BufRead *.livemd set filetype=markdown
  autocmd FileType elixir setlocal indentkeys+=end
  autocmd FileType eelixir setlocal indentkeys+=end
augroup end

let g:projectionist_heuristics['mix.exs'] = {
  \ 'apps/*/mix.exs': { 'type': 'app' },
  \ 'lib/*.ex': {
  \   'type': 'source',
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
  \ 'lib/**/controllers/*_controller.ex': {
  \   'type': 'controller',
  \   'alternate': 'test/{dirname}/controllers/{basename}_controller_test.exs',
  \   'template': [
  \     'defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}Controller do',
  \     '  use {dirname|camelcase|capitalize}, :controller',
  \     'end'
  \   ],
  \ },
  \ 'test/**/controllers/*_controller_test.exs': {
  \   'alternate': 'lib/{dirname}/controllers/{basename}_controller.ex',
  \   'type': 'test',
  \   'template': [
  \     'defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}ControllerTest do',
  \     '  use {dirname|camelcase|capitalize}.ConnCase, async: true',
  \     'end'
  \   ]
  \ },
  \ 'lib/**/live/*_live.ex': {
  \   'type': 'live',
  \   'alternate': 'test/{dirname}/live/{basename}_live_test.exs',
  \   'related': [
  \     '{dirname|dirname}/views/{basename}_view.ex'
  \   ],
  \   'template': [
  \     'defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}Live do',
  \     '  use {dirname|camelcase|capitalize}, :live_view',
  \     '',
  \     '  def mount(_params, _session, socket) do',
  \     '    if connected?(socket), do: :ok',
  \     '',
  \     '    {:ok, socket |> assign(:page_title, "Foo")}',
  \     '  end',
  \     '',
  \     '  def render(assigns) do',
  \     '    {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}View.render("foo.html", assigns)',
  \     '  end',
  \     'end'
  \   ]
  \ },
  \ '*eex': {
  \   'type': 'template',
  \   'related': [
  \     '{dirname|dirname|dirname}/controllers/{dirname|basename}_controller.ex',
  \     '{dirname|dirname|dirname}/live/{dirname|basename}_live.ex',
  \     '{dirname|dirname|dirname}/views/{dirname|basename}_view.ex'
  \   ]
  \ },
  \ 'lib/**/views/*_view.ex': {
  \   'type': 'view',
  \   'alternate': 'test/{dirname}/views/{basename}_view_test.exs',
  \   'related': [
  \     '{dirname|dirname}/live/{basename}_live.ex',
  \     '{dirname|dirname}/controllers/{basename}_controller.ex'
  \   ],
  \   'template': [
  \     'defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}View do',
  \     '  use {dirname|camelcase|capitalize}, :view',
  \     'end'
  \   ]
  \ },
  \ 'test/**/views/*_view_test.exs': {
  \   'alternate': 'lib/{dirname}/views/{basename}_view.ex',
  \   'type': 'test',
  \   'template': [
  \     'defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}ViewTest do',
  \     '  use ExUnit.Case, async: true',
  \     '',
  \     '  alias {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}View',
  \     'end'
  \   ]
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
