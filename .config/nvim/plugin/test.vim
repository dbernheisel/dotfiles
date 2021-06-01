function! RunTest(cmd)
  exec a:cmd
endfunction

function! RunTestSuite()
  if filereadable('bin/test_suite')
    TermExec cmd="echo 'bin/test_suite'"
    TermExec cmd="bin/test_suite"
  elseif filereadable("bin/test")
    TermExec cmd="echo 'bin/test'"
    TermExec cmd="bin/test"
  else
    TestSuite
  endif
endfunction

let test#strategy = "neovim"
let test#neovim#term_position = "botright 20"
let test#ruby#rspec#options = {
      \ 'nearest': '--backtrace',
      \ 'suite':   '--profile 5',
      \ }
let test#shell#bats#options = {
      \ 'nearest': '-t'
      \ }

nmap <silent> <leader>t :call RunTest('TestNearest')<CR>
nmap <silent> <leader>T :call RunTest('TestFile')<CR>
nmap <silent> <leader>a :call RunTestSuite()<CR>
nmap <silent> <leader>l :call RunTest('TestLast')<CR>
nmap <silent> <leader>g :call RunTest('TestVisit')<CR>
