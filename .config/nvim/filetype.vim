if exists("did_load_filetypes")
  finish
endif

augroup filetypedetect
  au! BufNewFile,BufRead *.env* setf env | setlocal syntax=sh
  au! BufNewFile,BufRead *.jsonc setf json
  au! BufNewFile,BufRead *.html.eex,*.html.leex,*.drab setf heex
  au! BufNewFile,BufRead Procfile,Brewfile setf ruby
  au! BufNewFile,BufRead *.md setf markdown
  au! BufNewFile,BufRead mix.lock setf elixir
  au! BufNewFile,BufRead *.arb setf eruby
  au! BufNewFile,BufRead irbrc,pryrc setf ruby
augroup END
