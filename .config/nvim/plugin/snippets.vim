lua require("dbern.snippets")

inoremap <c-k> <cmd>lua require('dbern.snippets').expand_or_jump()<CR>
snoremap <c-k> <cmd>lua require('dbern.snippets').expand_or_jump()<CR>

inoremap <c-j> <cmd>lua require('dbern.snippets').jump_back()<CR>
snoremap <c-j> <cmd>lua require('dbern.snippets').jump_back()<CR>

inoremap <c-l> <cmd>lua require('dbern.snippets').change_snippet()<CR>
snoremap <c-l> <cmd>lua require('dbern.snippets').change_snippet()<CR>

nnoremap <leader><leader>s <cmd>source ~/.config/nvim/lua/dbern/snippets.lua<CR>

