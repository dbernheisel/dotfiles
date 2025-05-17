-- silent! !git rev-parse --is-inside-work-tree
-- let s:git_project = v:shell_error == 0

local fzf = require('fzf-lua')
local U = require('dbern.utils')
local M = {}

local fd_opts = "--hidden -t f"
local rg_opts = "--files"
local has_prox = U.executable("proximity-sort")

local fzf_opts = {
  ['--layout'] = false
}

if has_prox then
  fzf_opts['--tiebreak'] = 'index'

  M.dynamic_fzf_args = function()
    if vim.fn.fnamemodify(vim.fn.expand('%'), ':h:.:S') ~= '.' then
      local opts = {}
      opts.rg_opts = rg_opts.." | proximity-sort "..vim.fn.expand('%')
      opts.fd_opts = fd_opts.." | proximity-sort "..vim.fn.expand('%')
      return opts
    end

    return {}
  end
else
  M.dynamic_fzf_args = function()
    return {}
  end
end

M.grep = function()
  return fzf.grep()
end

M.files = function()
  return fzf.files(M.dynamic_fzf_args)
--  return fzf.files()
end

M.vimrc = function()
  return fzf.files({
    prompt = "nvimrc❯ ",
    fd_opts = "--color=never --type f --exclude .netrwhist --exclude undo --exclude plugged",
    rg_opts = "--color=never --files -g '!.netrwhist' -g '!undo' -g '!plugged'",
    cwd = "~/.config/nvim"
  })
end

M.dotfiles = function()
  return fzf.files({
    prompt = "dotfiles❯ ",
    fd_opts = "--color=never --type f --exclude calibre/ --exclude tmux/plugins/tpm/ --exclude coc/ --exclude chromium/ --exclude yarn/ --exclude nvim/ --exclude pulse/ --exclude kak/plugins/",
    rg_opts = "--color=never --files -g '!calibre/' -g '!tmux/plugins/tmp/' -g '!coc/' -g '!chromium/' -g '!yarn/' -g '!nvim/' -g '!pulse/' -g '!kak/plugins/'",
    cwd = "~/.config"
  })
end

M.locals = function()
  return fzf.files({
    prompt = "local❯ ",
    fd_opts = "--color=never --type f --exclude include/ --exclude kitty.app/ --exclude lib/ --exclude share/ --exclude discord/",
    rg_opts = "--color=never --files -g '!include/' -g '!kitty.app/' -g '!lib/' -g '!share/' -g '!discord/'",
    cwd = "~/.local"
  })
end

M.git_branches = function()
  return fzf.git_branches()
end

_G.fzf_grep = M.grep
_G.fzf_files = M.files
_G.fzf_vimrc = M.vimrc
_G.fzf_dotfiles = M.dotfiles
_G.fzf_local = M.locals
_G.fzf_git_branches = M.git_branches

M.setup = function()
  fzf.setup({
    winopts = {
      fullscreen = true,
      border = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
      hls = { border = 'FloatBorder' },
      preview = {
        border = 'noborder',
        hidden = 'hidden'
      },
    },
    lsp = {
      includeDeclaration = false
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
      },
      builtin = {
        extensions = {
          ['png'] = { 'kitten', 'icat' },
          ['webp'] = { 'kitten', 'icat' },
          ['jpg'] = { 'kitten', 'icat' },
        },
      },
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

  -- fzf.register_ui_select({winopts = {preview = {winopts = {number = false}}}}, true)
end

return M
