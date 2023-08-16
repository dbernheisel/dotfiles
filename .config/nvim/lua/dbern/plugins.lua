local U = require("dbern.utils")

-- Recompile plugins after messing with plugins
vim.cmd [[
augroup packer_user_config
  autocmd!
  autocmd BufWritePost plugins.lua source <afile> | PackerCompile
augroup end
]]

-- Auto-install Packer if not installed
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- Plugins
return require('packer').startup({function(use)
  use 'wbthomason/packer.nvim'

  if not vim.g.vscode then
    use { 'kyazdani42/nvim-web-devicons',
      config = "require('dbern.plugins.nvim-web-devicons')" }

    -- LSP
    use 'williamboman/mason.nvim'
    use 'williamboman/mason-lspconfig.nvim'
    use { 'elixir-tools/elixir-tools.nvim',
      requires = { "nvim-lua/plenary.nvim" }
    }
    use 'mrshmllow/document-color.nvim'
    use { 'neovim/nvim-lspconfig', config = "require('dbern.lsp')" }
    use { 'folke/trouble.nvim',
      config = "require('dbern.plugins.trouble')" }
    use 'mfussenegger/nvim-jdtls'
    use { 'mhanberg/output-panel.nvim',
      config = "require('output_panel').setup()"
    }

    -- Completion
    use { 'hrsh7th/nvim-cmp', config = "require('dbern.plugins.completion')" }
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-calc'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/cmp-nvim-lsp-signature-help'
    use 'hrsh7th/cmp-nvim-lsp-document-symbol'

    -- Finders
    use 'nvim-lua/popup.nvim'
    -- use { 'nvim-telescope/telescope.nvim',
    --   requires = { {'nvim-lua/plenary.nvim'} },
    --   config = "require('dbern.plugins.telescope').setup()" }
    -- use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    if U.executable('/usr/local/opt/fzf/bin/fzf') then
      -- Use brew-installed fzf
      use '/usr/local/opt/fzf'
      vim.api.nvim_command("set rtp+=/usr/local/opt/fzf")
    elseif U.executable('/usr/bin/fzf') then
      -- Use arch-installed fzf
      vim.api.nvim_command("set rtp+=/usr/bin/fzf")
    else
      use { 'junegunn/fzf', run = ':call fzf#install()' }
    end
    use { 'ibhagwan/fzf-lua',
      requires = { 'kyazdani42/nvim-web-devicons' },
      config = { "require('dbern.plugins.fzf').setup()" }
    }
    use 'junegunn/fzf.vim'
    use { "nvim-neo-tree/neo-tree.nvim",
      config = { "require('dbern.plugins.neotree').setup()" },
      requires = {
        "nvim-lua/plenary.nvim",
        "kyazdani42/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
      }
    }

    -- Treesitter
    if U.has('nvim-0.6') then
      use { 'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = "require('dbern.plugins.treesitter').setup()" }
    else
      use { 'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = "require('dbern.plugins.treesitter').setup()",
        branch = '0.5-compat' }
    end
    use 'nvim-treesitter/playground'

    -- Terminal
    use { 'numToStr/FTerm.nvim',
      config = "require('dbern.plugins.fterm')" }

    -- Snippets
    use { 'L3MON4D3/LuaSnip', config = "require('dbern.plugins.snippets')" }
    use 'saadparwaiz1/cmp_luasnip'

    if U.is_mac then
      use { 'mrjones2014/dash.nvim',
        run = 'make install',
        config = "require('dbern.plugins.dash')" }
    end

    use 'norcalli/nvim-colorizer.lua'

    -- Search and Replace
    use { 'windwp/nvim-spectre', config = "require('dbern.plugins.spectre').setup()" }

    use { 'itchyny/calendar.vim',
      config = "require('dbern.plugins.calendar')" }

    -- <C-n> to select next word with new cursor
    use 'mg979/vim-visual-multi'

    -- Easier block commenting.
    use { 'scrooloose/nerdcommenter', config = "require('dbern.plugins.nerdcomment')" }

    -- Character as colorcolumn
    use { "lukas-reineke/virt-column.nvim", config = "require('virt-column').setup()" }

    -- Git
    use 'mhinz/vim-signify'
    use { 'NeogitOrg/neogit', config = "require('dbern.plugins.neogit')" }
    use { 'tpope/vim-fugitive', config = "require('dbern.plugins.fugitive')" }

    -- Resize panes with C-e and hjkl
    use { 'simeji/winresizer', config = [[
      vim.api.nvim_set_keymap('t', '<c-e>', '<c-\\><c-n>:WinResizerStartResize<cr>', { noremap = true })
    ]]}


    -- Theme
    use { 'sonph/onehalf', rtp = 'vim/'}
    use { 'sainnhe/sonokai', config = "require('dbern.theme').setup()" }
    use { 'hoob3rt/lualine.nvim', config = "require('dbern.plugins.lualine')" }
  end

  -- Add test commands
  use { "vim-test/vim-test", config = "require('dbern.plugins.test').setup()" }
  use { 'mfussenegger/nvim-dap', config = "require('dbern.plugins.dap')" }

  use 'tpope/vim-repeat'
  use 'tpope/vim-surround'
  use 'tpope/vim-eunuch'
  use 'tpope/vim-projectionist'
  use 'pbrisbin/vim-mkdir'

  use 'godlygeek/tabular'
  use 'reedes/vim-colors-pencil'
  use 'reedes/vim-pencil'
  use 'junegunn/limelight.vim'
  use 'junegunn/goyo.vim'
  use 'reedes/vim-wordy'

  if packer_bootstrap then
    require('packer').sync()
  end
end,
config = {
  display = {
    open_fn = require('packer.util').float
  }
}})

