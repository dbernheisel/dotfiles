let g:test#javascript#dendra#file_pattern = '\v(test|spec)\.(js|jsx|ts|tsx)$'

function! test#javascript#dendra#test_file(file) abort
  if a:file =~? g:test#javascript#dendra#file_pattern
    if exists('g:test#javascript#runner')
      return g:test#javascript#runner ==# 'dendra'
    endif
  endif
endfunction

function! test#javascript#dendra#build_position(type, position) abort
  let file = a:position['file']
  let [f] = split(file, '\vsrc\/(apps|libraries)\/')
  let idx = stridx(f, '/')
  let app = f[0:idx-1]
  let relative_file = f[idx+1:-1]
  let args = '--only '.app.' --path '.relative_file

  if a:type ==# 'nearest'
    " filtering doesn't work well with our setup
    "
    " let specname = s:nearest_test(a:position)
    " if empty(specname)
    "   return [args]
    " endif
    " let specname = '--grep ' . shellescape(specname, 1)
    return [args]
  elseif a:type ==# 'file'
    return [args]
  else
    return []
  endif
endfunction

function! test#javascript#dendra#build_args(args, color) abort
  let args = a:args

  " reduce clutter in the output by only reporting tests and only run once so
  " we take less time & therefore annoy the user less
  call extend(args, ['--single-run', '--no-auto-watch', '--log-level=disable'])

  if !a:color
    let args = ['--no-color'] + args
  endif

  return args
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#javascript#patterns)
  return join(name['namespace'] + name['test'])
endfunction

" Relies on a transformer to replace placeholder
let g:test#javascript#dendra#executable = 'yarn karma start {CONFIG}'
