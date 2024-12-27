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
  -- Theme
  { 'sonph/onehalf',
    lazy = false,
    config = function(plugin) vim.opt.rtp:append(plugin.dir .. '/vim') end },
  { 'sainnhe/sonokai',
    lazy = false,
    config = function() require('dbern.plugins.theme').setup() end },
  { 'hoob3rt/lualine.nvim',
    lazy = false,
    config = function() require('dbern.plugins.lualine') end },

  { "OXY2DEV/helpview.nvim",
    ft = "help",
    dependencies = {
      "nvim-treesitter/nvim-treesitter"
    }
  },

  {
    "OXY2DEV/markview.nvim",
    ft = "markdown",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons"
    }
  },

  -- LSP
  { 'williamboman/mason.nvim' },
  { 'williamboman/mason-lspconfig.nvim' },
  { 'elixir-tools/elixir-tools.nvim', dependencies = { "nvim-lua/plenary.nvim" } },
  {
    "luckasRanarison/tailwind-tools.nvim",
    name = "tailwind-tools",
    build = ":UpdateRemotePlugins",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "neovim/nvim-lspconfig",
    },
    opts = {} -- your configuration
  },
  { 'neovim/nvim-lspconfig',
    config = function() require('dbern.lsp') end },
  { 'folke/trouble.nvim',
    config = function() require('dbern.plugins.trouble') end,
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    }
  },
  { 'mfussenegger/nvim-jdtls' },

  {
      "3rd/image.nvim",
      opts = {}
  },

  -- Snippets

  -- Completion
  -- { 'hrsh7th/cmp-calc' },
  -- { 'hrsh7th/cmp-path' },
  -- { 'hrsh7th/cmp-cmdline' },
  -- { 'hrsh7th/cmp-nvim-lsp-signature-help' },
  -- { 'hrsh7th/cmp-nvim-lsp-document-symbol' },
  -- { 'hrsh7th/nvim-cmp',
  --   event = "InsertEnter",
  --   dependencies = {
  --     'hrsh7th/cmp-nvim-lsp',
  --     'hrsh7th/cmp-buffer',
  --     "luckasRanarison/tailwind-tools.nvim",
  --     "onsails/lspkind-nvim",
  --   },
  --   config = function() require('dbern.plugins.completion') end},
  -- { 'saadparwaiz1/cmp_luasnip' },
  {
    'saghen/blink.cmp',
    version = '0.*',
    dependencies = {
      { 'L3MON4D3/LuaSnip',
        version =  'v2.*',
        config = function() require('dbern.plugins.snippets') end},
      -- lock compat to tagged versions, if you've also locked blink.cmp to tagged versions
    },
    opts = {
      keymap = {
        preset = 'default' ,
        ['<C-j>'] = { 'select_next', 'fallback' },
        ['<C-k>'] = { 'select_prev', 'fallback' },
      },
      appearance = {
        nerd_font_variant = 'mono'
      },
      signature = { enabled = true },
      completion = {
        menu = { auto_show = function(ctx)
          return ctx.mode ~= 'cmdline' or not vim.tbl_contains({ '/', '?' }, vim.fn.getcmdtype())
        end },
      },
      sources = {
        default = function(ctx)
          local success, node = pcall(vim.treesitter.get_node)
          if success and node and vim.tbl_contains({ 'comment', 'line_comment', 'block_comment' }, node:type()) then
            return { 'buffer', 'path' }
          else
            return { 'lsp', 'path', 'luasnip', 'buffer' }
          end
        end,
        providers = {
          luasnip = {
            name = 'luasnip',
            score_offset = -3,
            opts = {
              use_show_condition = false,
              show_autosnippets = true,
            },
          },
        },
      },
      snippets = {
        expand = function(snippet) require('luasnip').lsp_expand(snippet) end,
        active = function(filter)
          if filter and filter.direction then
            return require('luasnip').jumpable(filter.direction)
          end
          return require('luasnip').in_snippet()
        end,
        jump = function(direction) require('luasnip').jump(direction) end
      },
    },
  },
  { 'mtrajano/tssorter.nvim',
    -- latest stable version, use `main` to keep up with the latest changes
    version = '*',
    config = function()
      local tssorter = require('tssorter')
      tssorter.setup({
        sortables = {
          elixir = {
            alias = {
              node = 'call',
              ordinal = 'arguments'
            },
            alias_group = {
              node = 'alias'
            }
          }
        }
      })

      vim.api.nvim_create_user_command('Sort', function()
        tssorter.sort()
      end, { nargs = 0 })
    end
  },

  -- Start Screen
  { "goolord/alpha-nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-lua/plenary.nvim",
    },
    config = function() require('dbern.plugins.start').setup() end
  },

  -- Finders
  { 'nvim-lua/popup.nvim' },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      { "JMarkin/nvim-tree.lua-float-preview",
        lazy = true,
      }
    },
    config = function()
      local function on_attach(bufnr)
        local api = require "nvim-tree.api"

        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        api.config.mappings.default_on_attach(bufnr)
        local FloatPreview = require("float-preview")
        FloatPreview.attach_nvimtree(bufnr)

        vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent, opts('Up'))
        vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
      end

      local HEIGHT_RATIO = 0.9
      local WIDTH_RATIO = 0.9

      require("nvim-tree").setup({
        view = {
          width = function()
            return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
          end,
          float = {
            enable = true,
            open_win_config = function()
              local screen_w = vim.opt.columns:get()
              local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
              local window_w = screen_w * WIDTH_RATIO
              local window_h = screen_h * HEIGHT_RATIO
              local window_w_int = math.floor(window_w)
              local window_h_int = math.floor(window_h)
              local center_x = (screen_w - window_w) / 2
              local center_y = ((vim.opt.lines:get() - window_h) / 2)
                              - vim.opt.cmdheight:get()
              return {
                border = 'rounded',
                relative = 'editor',
                row = center_y,
                col = center_x,
                width = window_w_int,
                height = window_h_int,
              }
            end,
          }
        },
        update_focused_file = { enable = true },
        on_attach = on_attach,
        git = { enable = false },
      })
    end,
    keys = {
      -- 👇 in this section, choose your own keymappings!
      {
        "<leader>b",
        "<cmd>NvimTreeFocus<cr>",
        desc = "Open explorer at the current file",
      }

    },
  },

  { -- Use brew-installed fzf
    dir = '/opt/homebrew/opt/fzf',
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
  { "junegunn/fzf",
    -- Ensure fzf is installed
    name = "fzf-neovim",
    cond = not U.executable('/opt/homebrew/bin/fzf') and not U.executable('/usr/bin/fzf'),
    build = ':call fzf#install()'
  },
  { "ibhagwan/fzf-lua",
    dependencies = {
      { "nvim-tree/nvim-web-devicons" }
    },
    config = function() require('dbern.plugins.fzf').setup() end
  },
  { "junegunn/fzf.vim" },
  { "nvim-neo-tree/neo-tree.nvim",
    config = function() require('dbern.plugins.neotree').setup() end,
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-tree/nvim-web-devicons" },
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

  { "jake-stewart/multicursor.nvim",
    branch = "1.0",
    config = function()
        local mc = require("multicursor-nvim")
        mc.setup()
        local set = vim.keymap.set
        -- Add or skip adding a new cursor by matching word/selection
        set({"n", "v"}, "<c-n>",
            function() mc.matchAddCursor(1) end)
        set({"n", "v"}, "<c-m>",
            function() mc.matchSkipCursor(1) end)
        set({"n", "v"}, "<c-s-n>",
            function() mc.matchAddCursor(-1) end)
        set({"n", "v"}, "<c-s-m>",
            function() mc.matchSkipCursor(-1) end)

        -- Rotate the main cursor.
        set({"n", "v"}, "<left>", mc.nextCursor)
        set({"n", "v"}, "<right>", mc.prevCursor)

        -- Delete the main cursor.
        set({"n", "v"}, "<c-x>", mc.deleteCursor)

        -- Add and remove cursors with control + left click.
        set("n", "<c-leftmouse>", mc.handleMouse)

        -- Easy way to add and remove cursors using the main cursor.
        set({"n", "v"}, "<c-q>", mc.toggleCursor)

        set("n", "<esc>", function()
            if not mc.cursorsEnabled() then
                mc.enableCursors()
            elseif mc.hasCursors() then
                mc.clearCursors()
            else
                -- Default <esc> handler.
            end
        end)

        -- Align cursor columns.
        set("n", "<leader>a", mc.alignCursors)

        -- Split visual selections by regex.
        set("v", "S", mc.splitCursors)

        -- Append/insert for each line of visual selections.
        set("v", "I", mc.insertVisual)
        set("v", "A", mc.appendVisual)

        -- match new cursors within visual selections by regex.
        set("v", "M", mc.matchCursors)

        -- Rotate visual selection contents.
        -- set("v", "<leader>t",
        --     function() mc.transposeCursors(1) end)
        -- set("v", "<leader>T",
            -- function() mc.transposeCursors(-1) end)

        -- Jumplist support
        set({"v", "n"}, "<c-i>", mc.jumpForward)
        set({"v", "n"}, "<c-o>", mc.jumpBackward)

        -- Customize how cursors look.
        local hl = vim.api.nvim_set_hl
        hl(0, "MultiCursorCursor", { link = "Cursor" })
        hl(0, "MultiCursorVisual", { link = "Visual" })
        hl(0, "MultiCursorSign", { link = "SignColumn"})
        hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
        hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
        hl(0, "MultiCursorDisabledSign", { link = "SignColumn"})
    end
  },

  -- Easier block commenting.
  { 'scrooloose/nerdcommenter',
    config = function() require('dbern.plugins.nerdcomment') end,
    cond = not U.has('nvim-0.10')
  },

  -- REST/GraphQL client
  -- {
  --   'mistweaverco/kulala.nvim',
  --   config = function()
  --     -- Setup is required, even if you don't pass any options
  --     require('kulala').setup()
  --   end
  -- },
  -- {
  --   'mistweaverco/kulala-cmp-graphql.nvim',
  --   config = function()
  --     local cmp = require('cmp')
  --     require('kulala-cmp-graphql').setup()
  --     cmp.setup.filetype("http", {
  --       sources = cmp.config.sources({
  --         { name = "kulala-cmp-graphql" },
  --       }, {
  --         { name = "buffer" },
  --       }),
  --     })
  --   end,
  --   dependencies = {
  --     'mistweaverco/kulala.nvim',
  --     'hrsh7th/nvim-cmp',
  --   }
  -- },

  -- Enhanced Marks
  { "cbochs/grapple.nvim",
    dependencies = {
      { "nvim-tree/nvim-web-devicons", lazy = true }
    },
    opts = { scope = "git" },
    event = { "BufReadPost", "BufNewFile" },
    cmd = "Grapple",
    keys = {
      { "<leader>m", "<cmd>Grapple toggle<cr>", desc = "Grapple toggle tag" },
      { "<leader>M", "<cmd>Grapple toggle_tags<cr>", desc = "Grapple open tags window" },
      { "<leader>n", "<cmd>Grapple cycle_tags next<cr>", desc = "Grapple cycle next tag" },
      { "<leader>p", "<cmd>Grapple cycle_tags prev<cr>", desc = "Grapple cycle previous tag" },
      { "<leader>1", "<cmd>Grapple select index=1<cr>", desc = "Grapple first tag" },
      { "<leader>2", "<cmd>Grapple select index=2<cr>", desc = "Grapple second tag" },
      { "<leader>3", "<cmd>Grapple select index=3<cr>", desc = "Grapple third tag" },
      { "<leader>4", "<cmd>Grapple select index=4<cr>", desc = "Grapple fourth tag" },
      { "<c-1>", "<cmd>Grapple tag index=1<cr>", desc = "Grapple first tag" },
      { "<c-2>", "<cmd>Grapple tag index=2<cr>", desc = "Grapple second tag" },
      { "<c-3>", "<cmd>Grapple tag index=3<cr>", desc = "Grapple third tag" },
      { "<c-4>", "<cmd>Grapple tag index=4<cr>", desc = "Grapple fourth tag" },
    },
  },

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
  { 'pwntester/octo.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      'ibhagwan/fzf-lua',
      'nvim-tree/nvim-web-devicons',
    },
    config = function ()
      require("octo").setup({
        suppress_missing_scope = {
          projects_v2 = true,
        },
        picker = "fzf-lua",
      })
    end },

  -- Resize panes with C-e and hjkl
  { 'simeji/winresizer',
    config = function()
      vim.api.nvim_set_keymap('t', '<c-e>', '<c-\\><c-n>:WinResizerStartResize<cr>', { noremap = true })
    end },


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
}, {
  rocks = {
    hererocks = true,
  },
})
