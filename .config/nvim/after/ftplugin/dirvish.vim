silent! :call dirvish#add_icon_fn({p -> p[-1:] == '/' ? '  ' : '🗎  '})
silent! unmap <buffer> <C-p>

silent! nmap <buffer> a <nop>
silent! nmap <buffer> o <nop>
silent! nmap <buffer> <ESC> :q<CR>

nnoremap <nowait><buffer><silent><C-V> :call dirvish#open("vsplit", 1)<CR>:q<CR>
nnoremap <nowait><buffer><silent><C-X> :call dirvish#open("split", 1)<CR>:q<CR>
nnoremap <nowait><buffer><silent><C-T> :call dirvish#open("tabedit", 1)<CR>:q<CR>

nnoremap <nowait><buffer><silent> % :call dirvish_helpers#make_file()<CR>
nnoremap <nowait><buffer><silent> d :call dirvish_helpers#make_directory()<CR>
nnoremap <nowait><buffer><silent> D :call dirvish_helpers#delete('d', 1)<CR>
nnoremap <nowait><buffer><silent> D :call dirvish_helpers#delete('rf', 1)<CR>

xnoremap <nowait><buffer><silent> % :call dirvish_helpers#make_file()<CR>
xnoremap <nowait><buffer><silent> d :call dirvish_helpers#make_directory()<CR>
xnoremap <nowait><buffer><silent> D :call dirvish_helpers#delete('d', 1)<CR>
xnoremap <nowait><buffer><silent> D :call dirvish_helpers#delete('rf', 1)<CR>
