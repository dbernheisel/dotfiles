augroup filetypedetect
  au! BufNewFile,BufRead .env,.env.*,.secrets setl syntax=sh | lua vim.diagnostic.disable()
  au! BufNewFile,BufRead *.json,*.hujson,*.jsonc,*.jsons,*.json5 setl filetype=json5
  au! BufNewFile,BufRead *.html.eex,*.html.leex,*.drab setl filetype=eelixir
  au! BufNewFile,BufRead *.heex,*.reex setl filetype=heex
  au! BufNewFile,BufRead Procfile,Brewfile setl filetype=ruby
  au! BufNewFile,BufRead *.md setl filetype=markdown
  au! BufNewFile,BufRead *.ex,*.exs,mix.lock setl filetype=elixir
  au! BufNewFile,BufRead mise.lock setl filetype=toml
  au! BufNewFile,BufRead *.arb setl filetype=eruby
  au! BufNewFile,BufRead *.service setl filetype=ini
  au! BufNewFile,BufRead *.pml setl filetype=markdown
  au! BufNewFile,BufRead irbrc,pryrc setl filetype=ruby
  au! BufNewFile,BufRead Caddyfile setl filetype=caddy
augroup END
