local U = require("dbern.utils")

-- Auto-install lazy.nvim if not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
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
    priority = 1000,
    lazy = false,
    config = function(plugin) vim.opt.rtp:append(plugin.dir .. '/vim') end },
  { 'sainnhe/sonokai',
    priority = 1000,
    lazy = false,
    init = function()
      vim.g.sonokai_transparent_background = true
      vim.g.sonokai_enable_italic = false
      vim.g.sonokai_disable_italic_comment = false
      vim.g.sonokai_better_performance = true
      -- Comment when italics are disabled
      -- vim.cmd [[let &t_ZH="\e[3m"]]
      -- vim.cmd [[let &t_ZR="\e[23m"]]

      require('dbern.plugins.theme')
      vim.api.nvim_set_keymap('n', '<leader>dm', ':call v:lua.dark_mode()<cr>', {})
      vim.api.nvim_set_keymap('n', '<leader>lm', ':call v:lua.light_mode()<cr>', {})
      vim.api.nvim_set_keymap('', '<f10>', ':call v:lua.current_highlights()<cr>', {})

      vim.o.background = 'dark'
      vim.cmd [[colorscheme sonokai]]
      if vim.g.lightline then
        vim.g.lightlight.colorscheme = 'sonokai'
      end
    end
  },
  { 'hoob3rt/lualine.nvim',
    lazy = false,
    config = function() require('dbern.plugins.lualine') end },

  -- LSP
  { 'williamboman/mason.nvim' },
  { 'williamboman/mason-lspconfig.nvim' },
  { 'elixir-tools/elixir-tools.nvim', dependencies = { "nvim-lua/plenary.nvim" } },
  {
    "luckasRanarison/tailwind-tools.nvim",
    lazy = true,
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
        "<leader>x",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnotics (Trouble)",
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
  { '3rd/image.nvim', lazy = true },
  {
    'narutoxy/silicon.lua',
    cond = U.executable('silicon'),
    dependencies = {
      { "nvim-lua/plenary.nvim" },
    },
    opts = {
      output = vim.env.HOME .. "/Desktop/" .. "SILICON_${year}-${month}-${date}_${time}.png",
      theme = 'OneHalfDark',
      font = 'FiraCode Nerd Font',
      lineNumber = false,
    },
    keys = {
      {
        '<leader>s', function()
          require('silicon').visualise_api({ visible = true })
        end, { mode = "v", desc = "Take Code Screenshot of Selected" }
      },
      {
        '<leader>ss', function()
          require('silicon').visualise_api({ show_buf = true })
        end, { mode = "v", desc = "Take Code Screenshot of Buffer" }
      },
      {
        '<leader>s', function()
          require('silicon').visualise_api({ show_buf = true })
        end, { des = "Take Code Screenshot of Line" }
      }
    }
  },
  {
    'saghen/blink.cmp',
    version = '0.*',
    dependencies = {
      { 'L3MON4D3/LuaSnip',
        version =  'v2.*',
        config = function() require('dbern.plugins.snippets') end},
    },
    opts = {
      fuzzy = {
        use_frecency = true,
        use_proximity = true,
      },
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
        menu = {
          auto_show = function(ctx)
            return ctx.mode ~= 'cmdline' or not vim.tbl_contains({ '/', '?' }, vim.fn.getcmdtype())
          end },
      },
      sources = {
        default = function(ctx)
          local success, node = pcall(vim.treesitter.get_node)
          if success and node and vim.tbl_contains({ 'comment', 'line_comment', 'block_comment' }, node:type()) then
            return { 'buffer', 'path' }
          else
            return { 'lsp', 'path', 'snippets', 'buffer' }
          end
        end,
      },
      snippets = {
        preset = 'luasnip',
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
    opts = {
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
    },
    config = function()
      vim.api.nvim_create_user_command('Sort', function()
        require('tssorter').sort()
      end, { nargs = 0 })
    end
  },
  { "cappyzawa/trim.nvim", config = {} },
  {
    "folke/snacks.nvim",
    priority = 1000,
    dependencies = {
      { "nvim-tree/nvim-web-devicons", lazy = true },
    },
    lazy = false,
    keys = {
      { "<leader>f", function() Snacks.picker.grep({ matcher = { cwd_bonus = true, frecency = true, sort_empty = true } }) end, desc = "Find text" },
      { "<leader>S", function() Snacks.scratch() end, desc = "Find text" },
      { "<c-p>", function() Snacks.picker.files({ matcher = { cwd_bonus = true, frecency = true, sort_empty = true } }) end, desc = "Find File" },
      { "<leader>ev", function() Snacks.picker.files({
        cwd = "~/.config/nvim",
        matcher = { cwd_bonus = true, frecency = true, sort_empty = true },
        exclude = { "undo/" }
      }) end, desc = "Find neovim file" },
      { "<leader>b", function() Snacks.picker.explorer({ auto_close = true }) end, desc = "Explore Files" },
      { "<leader>ed", function() Snacks.picker.files({ finder = "git_files", cwd = "~/.cfg" }) end, desc = "Find dotfile" },
      { "<leader>gco", function() Snacks.picker.git_branches() end, desc = "Find git branch" },
      { "<leader>n",  function() Snacks.notifier.show_history() end, desc = "Notification History" },
      { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
      { "]]",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
      { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
    { "<leader>gB",   function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
    },
    ---@type snacks.Config
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      bigfile = { enabled = true },
      dashboard = {
        enabled = true,
        preset = {
          header = table.concat({
"░▒▓███████▓▒░ ░▒▓██████▓▒░ ░▒▓██████▓▒░ ░▒▓███████▓▒░",
"░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░       ",
"░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░       ",
"░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░       ░▒▓██████▓▒░ ",
"░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░             ░▒▓█▓▒░",
"░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░",
"░▒▓███████▓▒░ ░▒▓██████▓▒░ ░▒▓██████▓▒░░▒▓███████▓▒░ ",
          }, "\n")
        },
        sections = {
          { section = "header" },
          { section = "keys", gap = 0, padding = 1 },
          { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = { 1, 1 } },
          { icon = " ", title = "Projects", section = "projects", indent = 2, padding = {1, 1} },
          {
            pane = 2,
            icon = " ",
            desc = "Browse Repo",
            padding = 1,
            key = "b",
            action = function()
              Snacks.gitbrowse()
            end,
          },
          function()
            local in_git = Snacks.git.get_root() ~= nil
            local cmds = {
              {
                title = "Open Issues",
                cmd = "gh issue list -L 3",
                key = "i",
                action = function()
                  vim.fn.jobstart("gh issue list --web", { detach = true })
                end,
                icon = " ",
                height = 7,
              },
              {
                icon = " ",
                title = "Open PRs",
                cmd = "gh pr list -L 3",
                key = "p",
                action = function()
                  vim.fn.jobstart("gh pr list --web", { detach = true })
                end,
                height = 7,
              },
              {
                icon = " ",
                title = "Git Status",
                cmd = "git --no-pager diff --stat -B -M -C",
                height = 10,
              },
            }
            return vim.tbl_map(function(cmd)
              return vim.tbl_extend("force", {
                pane = 2,
                section = "terminal",
                enabled = in_git,
                padding = 1,
                ttl = 5 * 60,
                indent = 3,
              }, cmd)
            end, cmds)
          end,
          { section = "startup" },
        },
      },
      explorer = {
        replace_netrw = true,
      },
      indent = {
        indent = { only_scope = true },
        animate = { enabled = false },
        enabled = true
      },
      input = {
        only_scope = true,
        enabled = true
      },
      notifier = {
        enabled = true,
        style = "minimal"
      },
      scope = {
        enabled = true,
        treesitter = {
          blocks = {
            enabled = true, -- enable to use the following blocks
            "function_declaration",
            "function_definition",
            "method_declaration",
            "method_definition",
            "class_declaration",
            "class_definition",
            "do_statement",
            "do_block",
            "while_statement",
            "repeat_statement",
            "if_statement",
            "for_statement",
          }
        },
      },
      picker = {
        enabled = true,
        -- layout = {
        --   box = "horizontal",
        --   reverse = true,
        --   width = 0.8,
        --   min_width = 120,
        --   height = 0.8,
        --   {
        --     box = "vertical",
        --     border = "rounded",
        --     title = "{title} {live} {flags}",
        --     { win = "list", border = "bottom" },
        --     { win = "input", height = 1, border = "none" },
        --   },
        --   { win = "preview", title = "{preview}", border = "rounded", width = 0.5 }
        -- },
      },
      quickfile = { enabled = true },
      -- statuscolumn = { enabled = true },
      words = { enabled = true },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd
        end
      })
      vim.api.nvim_create_autocmd("LspProgress", {
        ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
        callback = function(ev)
          local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
          vim.notify(vim.lsp.status(), 2, {
            id = "lsp_progress",
            title = "LSP Progress",
            opts = function(notif)
              notif.icon = ev.data.params.value.kind == "end" and " "
                or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
            end,
          })
        end,
      })
    end
  },

  -- Finders
  { 'nvim-lua/popup.nvim' },

  { -- Use brew-installed fzf
    dir = '/opt/homebrew/opt/fzf',
    name = 'fzf-brew',
    cond = U.executable('/opt/homebrew/bin/fzf'),
    config = function()
      vim.opt.rtp:append('/opt/homebrew/opt/fzf')
    end
  },
  { -- Use Intel brew-installed fzf
    dir = '/usr/local/opt/fzf',
    name = 'fzf-intel-brew',
    cond = U.executable('/usr/local/bin/fzf'),
    config = function()
      vim.opt.rtp:append('/usr/local/opt/fzf')
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
    cond = not U.executable('/usr/local/bin/fzf') and not U.executable('/opt/homebrew/bin/fzf') and not U.executable('/usr/bin/fzf'),
    build = ':call fzf#install()'
  },
  { "ibhagwan/fzf-lua",
    dependencies = {
      { "nvim-tree/nvim-web-devicons", lazy = true }
    },
    config = function() require('dbern.plugins.fzf').setup() end,
    keys = {
      -- { "<leader>f", ':call v:lua.fzf_grep()<cr>', desc = "Find text" },
      -- { "<c-p>", ':call v:lua.fzf_files()<cr>', desc = "Find file" },
      -- { "<leader>ev", ':call v:lua.fzf_vimrc()<cr>', desc = "Find vimrc file" },
      -- { "<leader>ed", ':call v:lua.fzf_dotfiles()<cr>', desc = "Find dotfile" },
      -- { "<leader>el", ':call v:lua.fzf_local()<cr>', desc = "Find local file" },
      -- { "<leader>gco", ':call v:lua.fzf_git_branches()<cr>', desc = "Find git branch" },
    },
  },
  { "junegunn/fzf.vim" },
  -- Treesitter
  { 'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = 'VeryLazy',
    opts = {
      ensure_installed = {
        'bash', 'css', 'dart', 'dockerfile', 'erlang', 'elixir', 'go', 'eex',
        'heex', 'html', 'graphql', 'sql', 'javascript', 'jsonc', 'kotlin',
        'git_config', 'gitattributes', 'gitcommit', 'gitignore', 'git_rebase',
        'gleam', 'diff', 'make', 'swift', 'scheme', 'ssh_config', 'toml', 'http',
        'lua', 'markdown', 'markdown_inline', 'php', 'python', 'regex', 'ruby',
        'rust', 'scss', 'surface', 'svelte', 'toml', 'tsx', 'typescript',
        'vue', 'yaml', 'zig', 'mermaid'
      },
      indent = { enable = true },
      highlight = { enable = true },
      incremental_selection = { enable = true },
      textobjects = { enable = true },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
     event = 'VeryLazy',
  },
  { 'nvim-treesitter/playground',
     event = 'VeryLazy',
  },

  -- Terminal
  { 'numToStr/FTerm.nvim',
    init = function() require('dbern.plugins.fterm').setup() end },

  { 'mrjones2014/dash.nvim',
    cond = U.is_mac and U.app_installed("Dash.app"),
    build = 'make install',
    keys = {
      { "<leader>d", ":DashWord<CR>", desc = "Open Dash on Word" },
    },
  },
  { 'norcalli/nvim-colorizer.lua' },

  -- Search and Replace
  { 'windwp/nvim-spectre',
    lazy = true,
    keys = {
      { '<leader>sr', function() require('spectre').open() end, desc = "Find/Replace" },
      { '<leder>srw', function() require('spectre').open_visual() end, desc = "Find/Replace Word", mode = { "n", "v" } },
      { '<leader>sp', function() require('spectre').open_file_search() end, desc = "Find/Replace in Buffer" },

    },
  },

  { 'itchyny/calendar.vim',
    lazy = true,
    keys = {
      { "<leader>cal", ":Calendar -view=year -split=horizontal -position=bottom -height=12<cr>", desc = "Open Calendar"}
    },
  },

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
  { "mhanberg/output-panel.nvim", event = "VeryLazy" },
  -- Git
  { 'mhinz/vim-signify' },
  { 'NeogitOrg/neogit',
    lazy = true,
    keys = {
      { "<leader>g", ":Neogit<cr>", desc = "Open Neogit" }
    }
  },
  { 'tpope/vim-fugitive' },
  { 'pwntester/octo.nvim',
    lazy = true,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'ibhagwan/fzf-lua',
      { "nvim-tree/nvim-web-devicons", lazy = true }
    },
    opts = {
      suppress_missing_scope = {
        projects_v2 = true,
      },
      picker = "fzf-lua",
    },
  },

  -- Resize panes with C-e and hjkl
  { 'simeji/winresizer',
    keys = {
      { '<c-e>', '<c-\\><c-n>:WinResizerStartResize<cr>', mode = 't'}
    }
  },

  -- Add test commands
  { "vim-test/vim-test",
    config = function() require('dbern.plugins.test').setup() end,
    keys = {
      { '<leader>t', ':TestNearest<cr>', desc = "Test Nearest" },
      { '<leader>T', ':TestFile<cr>', desc = "Test File" },
      { '<leader>l', ':TestLast<cr>', desc = "Test Last" },
      { '<leader>a', ':call v:lua.run_test_suite()<cr>', desc = "Test All" },
    },
  },
  { "andythigpen/nvim-coverage",
    lazy = true,
    opts = {
      commands = true,
      highlights = {
        covered = { fg = "#C3E88D" },
        uncovered = { fg = "#F07178" },
      },
      signs = {
        covered = { hl = "CoverageCovered", text = "▎" },
        uncovered = { hl = "CoverageUncovered", text = "▎" },
      },
      summary = {
        min_coverage = 80.0,
      },
      lang = {},
    },
    dependencies = {
      { "nvim-lua/plenary.nvim" },
    }
  },

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
