-- silent! !git rev-parse --is-inside-work-tree
-- let s:git_project = v:shell_error == 0

local fzf = require('fzf-lua')
local U = require('dbern.utils')
local M = {}

local fd_opts = "-t f"
local rg_opts = "--files"
local has_prox = U.executable("proximity-sort")
local previewer = "builtin"

local fzf_opts = {
  ['--layout'] = false
}
if has_prox then
  fzf_opts['--tiebreak'] = 'index'
end

if U.executable("bat") then
  previewer = "bat"
end

M.dynamic_fzf_args = function()
  if has_prox and vim.fn.fnamemodify(vim.fn.expand('%'), ':h:.:S') ~= '.' then
    local opts = {}
    opts.rg_opts = rg_opts.." | proximity-sort "..vim.fn.expand('%')
    opts.fd_opts = fd_opts.." | proximity-sort "..vim.fn.expand('%')
    return opts
  end

  return {}
end

M.grep = function()
  return fzf.grep()
end

M.files = function()
  return fzf.files(M.dynamic_fzf_args)
end

_G.fzf_grep = M.grep
_G.fzf_files = M.files

M.setup = function()
  -- silent! !git rev-parse --is-inside-work-tree
  -- let s:git_project = v:shell_error == 0

  fzf.setup({
    winopts = {
      border = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
      preview = {
        border = 'noborder',
        default = previewer,
        hidden = 'hidden'
      },
    },
    fzf_opts = fzf_opts,
    files = {
      fd_opts = fd_opts,
      rg_opts = rg_opts,
      input_prompt = "Files❯ ",
      git_icons = false,
      prompt = "Files❯ "
    },
    grep = {
      input_prompt = "Rg❯ ",
      prompt = "Rg❯ "
    },
    previewers = {
      bat = {
        theme = "Monokai Extended"
      }
    },
    keymap = {
      fzf = {
        -- fzf '--bind=' options
        ["ctrl-z"]      = "abort",
        ["ctrl-u"]      = "unix-line-discard",
        ["ctrl-f"]      = "half-page-down",
        ["ctrl-b"]      = "half-page-up",
        ["ctrl-a"]      = "beginning-of-line",
        ["ctrl-e"]      = "end-of-line",
        ["alt-a"]       = "toggle-all",
        -- Only valid with fzf previewers (bat/cat/git/etc)
        ["f3"]          = "toggle-preview-wrap",
        ["ctrl-/"]      = "toggle-preview",
        ["shift-down"]  = "preview-page-down",
        ["shift-up"]    = "preview-page-up",
      },
    }
  })

  vim.api.nvim_set_keymap('n', '<leader>f', ':call v:lua.fzf_grep()<cr>', { silent = true, noremap = true })
  vim.api.nvim_set_keymap('n', '<c-p>', ':call v:lua.fzf_files()<cr>', { silent = true, noremap = true })
  fzf.register_ui_select()
end

return M
