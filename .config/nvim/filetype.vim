if exists("did_load_filetypes")
  finish
endif

function! s:DetectElixir()
  if (!did_filetype() || &filetype !=# 'elixir') && getline(1) =~# '^#!.*\<elixir\>'
    setf elixir
  endif
endfunction

augroup filetypedetect
  au! BufNewFile,BufRead *.env* setf env | setlocal syntax=sh
  au! BufNewFile,BufRead *.jsonc setf json
  au! BufNewFile,BufRead *.ex,*.exs setf elixir
  au! BufNewFile,BufRead *.html.eex,*.html.leex,*.drab setf eelixir
  au! BufNewFile,BufRead Procfile,Brewfile setf ruby
  au! BufNewFile,BufRead *.md setf markdown
  au! BufNewFile,BufRead mix.lock setf elixir
  au! BufNewFile,BufRead *.arb setf eruby
  au! BufNewFile,BufRead irbrc,pryrc setf ruby
  au! BufNewFile,BufRead * call s:DetectElixir()
augroup END
