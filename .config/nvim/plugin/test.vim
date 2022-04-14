lua require('dbern.test')

" nmap <silent> <leader>t :TestNearest<CR>
" nmap <silent> <leader>T :TestFile<CR>
" nmap <silent> <leader>l :TestLast<CR>
nmap <silent> <leader>t :UltestNearest<CR>
nmap <silent> <leader>T :Ultest<CR>
nmap <silent> <leader>l :UltestLast<CR>
nmap <silent> <leader>a :call RunTestSuite()<CR>
nmap <silent> <leader>ta :UltestAttach<CR>
nmap <silent> <leader>to <Plug>(ultest-output-jump)<CR>
nmap <silent> <leader>ts :UltestSummary!<CR>

let g:ultest_running_sign = "ﰌ"
let g:ultest_summary_width = 75

function! FTermStrategy(cmd)
  call luaeval("require('dbern.terminal').run_in_test({run = _A})", a:cmd)
endfunction

let g:test#custom_strategies = {'FTerm': function('FTermStrategy')}
let g:test#strategy = 'FTerm'

let test#custom_runners = {
      \ 'ruby': ['payserver'],
      \ 'javascript': ['payserver'],
      \ 'java': ['uppsala']
      \ }

if fnamemodify(getcwd(), ':p') == $HOME.'/stripe/pay-server/'
  let test#enabled_runners = ["ruby#payserver", "javascript#payserver"]
end

if fnamemodify(getcwd(), ':p') == $HOME.'/stripe/zoolander/'
  let test#enabled_runners = ["java#uppsala"]
end

function! RunTestSuite()
  if filereadable('bin/test_suite')
    lua require('dbern.terminal').run_in_test({run = "bin/test_suite"})
  elseif filereadable("bin/test")
    lua require('dbern.terminal').run_in_test({run = "bin/test"})
  else
    TestSuite
  endif
endfunction

let test#shell#bats#options = {
      \ 'nearest': '-t'
      \ }

augroup stripe_projectionist
  autocmd!
  autocmd User ProjectionistDetect call s:stripe_configure_projectionist(g:projectionist_file)
  autocmd BufEnter *.rb call s:config_alternates_pay_server(expand("<afile>:p"))
augroup END

function! s:stripe_configure_projectionist(buffer_path)
  call s:config_alternates_stripe_js_v3(a:buffer_path)
endfunction

function! s:config_alternates_stripe_js_v3(buffer_path)
  if a:buffer_path =~ "stripe/stripe-js-v3"
    let l:projections = {
      \ "*.test.js": { 'alternate': '{}.js' },
      \ "*.js": { 'alternate': '{}.test.js' },
    \}

    call projectionist#append(getcwd(), l:projections)
  endif
endfunction

function! s:find_test_directory(path)
  let l:directory = fnamemodify(a:path, ":p:h")
  let l:relative_dir = substitute(l:directory, getcwd() . "/*", "", "")
  let l:pieces = split(l:relative_dir, "/")

  while len(l:pieces) > 0
    let l:current_dir = join(l:pieces, "/")
    let l:possible_test_dir = l:current_dir . "/test"

    if isdirectory(l:possible_test_dir)
      " found the test dir
      return { 'root': l:current_dir, 'test_dir': l:possible_test_dir }
    endif

    call remove(l:pieces, -1)
  endwhile

  return {}
endfunction

function! s:config_alternates_pay_server(buffer_path)
  if a:buffer_path =~ "stripe/pay-server"
    if empty(get(b:, 'stripe_projectionist_registered_files'))
      let b:stripe_projectionist_registered_files = {}
    endif

    if get(b:stripe_projectionist_registered_files, a:buffer_path)
      " we already did a recursive search in this buffer, let's not do it
      " again
      return
    endif

    if empty(get(b:, 'projectionist'))
      let b:projectionist = getbufvar('#', 'projectionist')
    endif

    let l:search = s:find_test_directory(a:buffer_path)

    " mark that we've already done the expensive search
    let b:stripe_projectionist_registered_files[a:buffer_path] = 1

    if l:search == {}
      return
    endif

    let l:projections = {}
    let l:projections[l:search['root'] . "/*"] =
      \ {
      \   'alternate': l:search['test_dir'] . "/{}",
      \ }

    let l:projections[l:search['test_dir'] . "/*"] =
      \ {
      \   'alternate': l:search['root'] . "/{}",
      \ }

    call projectionist#append(getcwd(), l:projections)
  endif
endfunction
