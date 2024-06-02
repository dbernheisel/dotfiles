local U = require("dbern.utils")

-- Auto-install lazy.nvim if not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-- Start lazy.nvim
require("lazy").setup({
  -- LSP
  { 'williamboman/mason.nvim' },
  { 'williamboman/mason-lspconfig.nvim' },
  { 'elixir-tools/elixir-tools.nvim', dependencies = { "nvim-lua/plenary.nvim" } },
  { 'themaxmarchuk/tailwindcss-colors.nvim' },
  { 'neovim/nvim-lspconfig',
    config = function() require('dbern.lsp') end },
  { 'folke/trouble.nvim',
    config = function() require('dbern.plugins.trouble') end },
  { 'mfussenegger/nvim-jdtls' },

  -- Snippets
  { 'L3MON4D3/LuaSnip',
    config = function() require('dbern.plugins.snippets') end},

  -- Completion
  { 'hrsh7th/cmp-calc' },
  { 'hrsh7th/cmp-path' },
  { 'hrsh7th/cmp-cmdline' },
  { 'hrsh7th/cmp-nvim-lsp-signature-help' },
  { 'hrsh7th/cmp-nvim-lsp-document-symbol' },
  { 'hrsh7th/nvim-cmp',
    event = "InsertEnter",
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-buffer' }
    },
    config = function() require('dbern.plugins.completion') end},
  { 'saadparwaiz1/cmp_luasnip' },

  -- Finders
  { 'nvim-lua/popup.nvim' },

  { -- Use brew-installed fzf
    dir = '/usr/local/opt/fzf',
    name = 'fzf-brew',
    cond = U.executable('/opt/homebrew/bin/fzf'),
    config = function()
      vim.opt.rtp:append('/opt/homebrew/opt/fzf')
    end
  },
  { -- Use arch-installed fzf
    dir = '/usr/local/opt/fzf',
    name = 'fzf-arch',
    cond = U.executable('/usr/bin/fzf'),
    config = function()
      vim.opt.rtp:append('/usr/bin/fzf')
    end
  },
  { 'junegunn/fzf',
    -- Ensure fzf is installed
    name = 'fzf-neovim',
    cond = not U.executable('/opt/homebrew/bin/fzf') and not U.executable('/usr/bin/fzf'),
    build = ':call fzf#install()'
  },
  { 'ibhagwan/fzf-lua',
    dependencies = {
      { 'kyazdani42/nvim-web-devicons' }
    },
    config = function() require('dbern.plugins.fzf').setup() end
  },
  { 'junegunn/fzf.vim' },
  { "nvim-neo-tree/neo-tree.nvim",
    config = function() require('dbern.plugins.neotree').setup() end,
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "kyazdani42/nvim-web-devicons" },
      { "MunifTanjim/nui.nvim" },
    }
  },
  -- Treesitter
  { 'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function() require('dbern.plugins.treesitter').setup() end },
  { 'nvim-treesitter/playground' },

  -- Terminal
  { 'numToStr/FTerm.nvim',
    init = function() require('dbern.plugins.fterm').setup() end },

  { 'mrjones2014/dash.nvim',
    cond = U.is_mac,
    build = 'make install',
    config = function() require('dbern.plugins.dash') end },

  { 'norcalli/nvim-colorizer.lua' },

  -- Search and Replace
  { 'windwp/nvim-spectre',
    config = function() require('dbern.plugins.spectre').setup() end },

  { 'itchyny/calendar.vim',
    config = function() require('dbern.plugins.calendar') end },

  -- <C-n> to select next word with new cursor
  { 'mg979/vim-visual-multi' },

  -- Easier block commenting.
  { 'scrooloose/nerdcommenter',
    config = function() require('dbern.plugins.nerdcomment') end },

  -- Character as colorcolumn
  { "lukas-reineke/virt-column.nvim"},

  -- View LSP logs
  {
    "mhanberg/output-panel.nvim",
    event = "VeryLazy",
    config = function() require("output_panel").setup() end },

  -- Git
  { 'mhinz/vim-signify' },
  { 'NeogitOrg/neogit',
    config = function() require('dbern.plugins.neogit') end },
  { 'tpope/vim-fugitive',
    config = function() require('dbern.plugins.fugitive') end },

  -- Resize panes with C-e and hjkl
  { 'simeji/winresizer',
    config = function()
      vim.api.nvim_set_keymap('t', '<c-e>', '<c-\\><c-n>:WinResizerStartResize<cr>', { noremap = true })
    end },


  -- Theme
  { 'sonph/onehalf',
    lazy = false,
    config = function(plugin) vim.opt.rtp:append(plugin.dir .. '/vim') end },
  { 'sainnhe/sonokai',
    lazy = false,
    config = function() require('dbern.theme').setup() end },
  { 'hoob3rt/lualine.nvim',
    lazy = false,
    config = function() require('dbern.plugins.lualine') end },

  -- Add test commands
  { "vim-test/vim-test",
    config = function() require('dbern.plugins.test').setup() end },
  { 'mfussenegger/nvim-dap',
    config = function() require('dbern.plugins.dap') end },
  { "andythigpen/nvim-coverage",
    config = function() require("dbern.plugins.coverage").setup() end,
    dependencies = {
      { "nvim-lua/plenary.nvim" },
    }},

  -- Convenience
  { 'tpope/vim-repeat' },
  { 'tpope/vim-surround' },
  { 'tpope/vim-eunuch' },
  { 'tpope/vim-projectionist' },
  { 'pbrisbin/vim-mkdir' },

  -- Write better
  { 'godlygeek/tabular' },
  { 'reedes/vim-colors-pencil' },
  { 'reedes/vim-pencil' },
  { 'junegunn/limelight.vim' },
  { 'junegunn/goyo.vim' },
  { 'reedes/vim-wordy' },
}, {})
