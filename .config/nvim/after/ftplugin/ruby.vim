function! TaxJarRspec(cmd) abort
  silent call system("cat README.md | grep 'TaxJar Reporting App'")
  if match(a:cmd, '--profile') == -1 && v:shell_error == 0
    return substitute(a:cmd, 'bundle exec', 'SKIP_FIXTURES=true bundle exec', '')
  else
    return a:cmd
  endif
endfunction

let g:test#custom_transformations = {
      \ 'taxjar_ruby': function('TaxJarRspec')
      \ }
let g:test#transformation = 'taxjar_ruby'
