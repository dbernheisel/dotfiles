vim.cmd [[
  augroup vimrcEx
    autocmd!

    " Open to last line after close
    autocmd BufReadPost *
      \ if &ft != 'gitcommit' && line("'\"") > 1 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif

    " JSON w/ comments
    autocmd FileType json syntax match Comment +\/\/.\+$+

    " Resize panes when window resizes
    autocmd VimResized * :wincmd =
  augroup END
]]

vim.cmd [[
  augroup netrwEx
    " Turn off line numbers in file tree
    autocmd FileType netrw setlocal nonumber norelativenumber
    autocmd FileType netrw setlocal colorcolumn=
  augroup END
]]

vim.cmd [[
  augroup terminalEx
    " Turn off line numbers in :terminal
    au TermOpen * setlocal nonumber norelativenumber nocursorline
    au TermOpen * set winhighlight=Normal:BlackBg
  augroup END
]]

-- Set wezterm user var so wezterm can detect nvim through zellij
if os.getenv('TERM_PROGRAM') == 'WezTerm' then
  vim.api.nvim_create_autocmd({ 'VimEnter', 'VimResume' }, {
    group = vim.api.nvim_create_augroup('WeztermUserVar', { clear = true }),
    callback = function()
      io.write('\027]1337;SetUserVar=IS_NVIM=dHJ1ZQ==\a')
    end,
  })
  vim.api.nvim_create_autocmd({ 'VimLeave', 'VimSuspend' }, {
    group = 'WeztermUserVar',
    callback = function()
      io.write('\027]1337;SetUserVar=IS_NVIM=\a')
    end,
  })
end

-- Clean up buffers when switching projects
vim.api.nvim_create_autocmd('DirChanged', {
  group = vim.api.nvim_create_augroup('ProjectSwitchCleanup', { clear = true }),
  pattern = 'global',
  callback = function()
    require('dbern.buffer_cleanup').cleanup_old_buffers()
  end,
  desc = 'Clean up buffers when switching projects'
})

vim.api.nvim_create_autocmd({'BufReadPost', 'BufWritePost'}, {
  desc = 'Autodetect extension-less filetypes',
  pattern = '*',
  group = vim.api.nvim_create_augroup('Shebang', { clear = true }),
  callback = function()
    local first_line = vim.fn.getline(1)
    if string.match(first_line, '^#!.*/bin/bash') or string.match(first_line, '^#!.*/bin/env%s+bash') then
      vim.bo.filetype = 'bash'
    end
  end
})

local api = vim.api

---@type integer?
local win_id = nil

---@type integer?
local buf_id = nil

---@type { row: integer, col_offset: integer }
local config = {
	row = 2,
	col_offset = 4,
}

---@return nil
local function close_banner()
	if win_id and api.nvim_win_is_valid(win_id) then
		api.nvim_win_close(win_id, true)
	end

	if buf_id and api.nvim_buf_is_valid(buf_id) then
		api.nvim_buf_delete(buf_id, { force = true })
	end

	win_id = nil
	buf_id = nil
end

---@return nil
local function open_banner()
	local reg = vim.fn.reg_recording()

	if reg == '' then
		return
	end

	close_banner()

	local text = string.format(' ● REC @%s ', reg)

	buf_id = api.nvim_create_buf(false, true)
	api.nvim_buf_set_lines(buf_id, 0, -1, false, { text })

	local col = vim.o.columns - #text - config.col_offset

	win_id = api.nvim_open_win(buf_id, false, {
		relative = 'editor',
		width = #text,
		height = 1,
		row = config.row,
		col = col,
		style = 'minimal',
		border = 'none',
		focusable = false,
		zindex = 150,
	})

	api.nvim_set_option_value(
		'winhighlight',
		'Normal:DiagnosticError',
		{ win = win_id }
	)
end

local group = api.nvim_create_augroup('MacroRecordingBanner', { clear = true })

api.nvim_create_autocmd(
	'RecordingEnter',
	{ group = group, callback = open_banner }
)

api.nvim_create_autocmd('RecordingLeave', {
	group = group,
	callback = function()
		vim.defer_fn(close_banner, 50)
	end,
})

api.nvim_create_autocmd('VimResized', {
	group = group,
	callback = function()
		if win_id and api.nvim_win_is_valid(win_id) then
			open_banner()
		end
	end,
})
