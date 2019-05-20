"let g:LanguageClient_autoStart = 1
"let g:LanguageClient_serverCommands = {}

"nnoremap <silent> <c-]> :call LanguageClient#textDocument_definition()<CR>

"if executable('javascript-typescript-stdio')
  "" yarn global add javascript-typescript-langserver   -or-
  "" npm i -g javascript-typescript-langserver
  "let g:LanguageClient_serverCommands['javascript'] = ['javascript-typescript-stdio']
  "let g:LanguageClient_serverCommands['typescript'] = ['javascript-typescript-stdio']
  "let g:LanguageClient_serverCommands['javascript.jsx'] = ['javascript-typescript-stdio']
"endif

"if executable('html-languageserver')
  "" yarn global add vscode-html-languageserver-bin   -or-
  "" npm i -g vscode-html-languageserver-bin
  "let g:LanguageClient_serverCommands.html = ['html-languageserver', '--stdio']
"endif

"if executable('css-languageserver')
  "" yarn global add vscode-css-languageserver-bin   -or-
  "" npm i -g vscode-css-languageserver-bin
  "let g:LanguageClient_serverCommands.css = ['css-languageserver', '--stdio']
  "let g:LanguageClient_serverCommands.less = ['css-languageserver', '--stdio']
"endif

"if executable('json-languageserver')
  "" yarn global add vscode-json-languageserver-bin   -or-
  "" npm i -g vscode-json-languageserver-bin
  "let g:LanguageClient_serverCommands.json = ['json-languageserver', '--stdio']
"endif

"if executable('ocaml-language-server')
  "" yarn global add ocaml-language-server   -or-
  "" npm i -g ocaml-language-server
  "let g:LanguageClient_serverCommands.reason = ['ocaml-language-server', '--stdio']
  "let g:LanguageClient_serverCommands.ocaml = ['ocaml-language-server', '--stdio']
"endif

"if executable('language_server.sh')
  "" git clone git@github.com:JakeBecker/elixir-ls.git ~/.elixir_ls
  "" cd ~/.elixir_ls
  "" mix deps.get && mix compile
  "" mix elixir_ls.release -o ./release
  "" add it to the $PATH

  "let g:LanguageClient_serverCommands.elixir = ['language_server.sh']
"endif

"if executable('kotlin-language-server')
  "" git clone git@github.com:fwcd/KotlinLanguageServer.git ~/.kotlin_ls
  "" cd ~/.kotlin_ls
  "" ./gradlew installDist
  "" export ~/.kotlin_ls/build/install/kotlin-language-server/bin/ to the $PATH
  "let g:LanguageClient_serverCommands.kotlin = ['kotlin-language-server']
"endif

"if executable('pyls')
  "" pip install python-language-server
  "let g:LanguageClient_serverCommands.python = ['pyls']
"endif

"if executable('solargraph')
  "" gem install solargraph
  "let g:LanguageClient_serverCommands.ruby = ['solargraph', 'stdio']
  "endif

"func! s:setup_ls(...) abort
  "let l:servers = lsp#get_whitelisted_servers()

  "for l:server in l:servers
    "let l:cap = lsp#get_server_capabilities(l:server)

    "if has_key(l:cap, 'completionProvider')
      "setlocal omnifunc=lsp#complete
    "endif

    "if has_key(l:cap, 'hoverProvider')
      "setlocal keywordprg=:LspHover
    "endif

    "if has_key(l:cap, 'definitionProvider')
      "nmap <silent> <buffer> gd <plug>(lsp-definition)
    "endif

    "if has_key(l:cap, 'referencesProvider')
      "nmap <silent> <buffer> gr <plug>(lsp-references)
    "endif
  "endfor
"endfunc

"augroup LSC
  "autocmd!

  "autocmd User lsp_setup call lsp#register_server({
    "\ 'name': 'ElixirLS',
    "\ 'cmd': {_->[&shell, &shellcmdflag, 'ERL_LIBS=~/elixir_ls/release language_server.sh']},
    "\ 'whitelist': ['elixir', 'eelixir']
    "\})

  "autocmd User lsp_setup call lsp#register_server({
    "\ 'name': 'solargraph',
    "\ 'cmd': {server_info->['solargraph', 'stdio']},
    "\ 'initialization_options': {"diagnostics": "true"},
    "\ 'whitelist': ['ruby'],
    "\ })

  "autocmd User lsp_server_init call <SID>setup_ls()
  "autocmd BufEnter * call <SID>setup_ls()
  "augroup END

let g:ale_elixir_elixir_ls_release = '/home/dbernheisel/.elixir_ls/release'
