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
  { "bluz71/vim-moonfly-colors",
    name = "moonfly",
    priority = 1000,
    lazy = false,
    config = function()
      vim.g.moonflyCursorColor = true
      vim.g.moonflyTransparent = true
      require('dbern.plugins.theme')
      vim.api.nvim_set_keymap('', '<f10>', ':call v:lua.current_highlights()<cr>', {})
      vim.cmd([[colorscheme moonfly]])
    end
  },
  { 'hoob3rt/lualine.nvim',
    lazy = false,
    config = function() require('dbern.plugins.lualine') end },

  -- -- LSP
  -- { 'mason-org/mason-lspconfig.nvim',
  --   opts = {
  --     automatic_enable = false,
  --     ensure_installed = { "bashls", "cssls", "dockerls", "html", "jsonls", "markdown_oxide",
  --       "solargraph", "kotlin_language_server", "lua_ls", "tailwindcss", "ts_ls", "vimls",
  --       "vuels", "ruby_lsp", "sqlls", "yamlls", "zls" }
  --   },
  --   dependencies = {
  --     { 'mason-org/mason.nvim', opts = {} }
  --   }
  -- },

  {
    "luckasRanarison/tailwind-tools.nvim",
    name = "tailwind-tools",
    build = ":UpdateRemotePlugins",
    dependencies = {
      "nvim-treesitter/nvim-treesitter"
    },
    opts = {}
  },
  { 'folke/trouble.nvim',
    opts = {
      use_diagnostic_signs = true,
    },
    cmd = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnotics (Trouble)" },
      { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
      { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions / references / ... (Trouble)" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
    }
  },
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod', lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', lazy = true },
    },
    cmd = { 'DBUI', 'DBUIToggle', 'DBUIAddConnection', 'DBUIFindBuffer' },
    keys = {
      { "<leader>db", "<cmd>DBUIToggle<cr>", desc = "Open Dadbod UI" },
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
  { "dbernheisel/run-or-comp",
    ft = "elixir",
    config = function()
      vim.api.nvim_set_hl(0, "RunorcompCompileTime", { bg = "#1a1a2e" })
      vim.api.nvim_set_hl(0, "RunorcompLabel", { fg = "#6e6ea8", italic = true })
      require("runorcomp").setup()
    end,
  },
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
        end, mode = 'v', desc = 'Take Code Screenshot of visible'
      },
      {
        '<leader>sb', function()
          require('silicon').visualise_api({ visible = true })
        end, mode = 'n', desc = 'Take Code Screenshot of visible'
      },
      {
        '<leader>sbb', function()
          require('silicon').visualise_api({ show_bug = true })
        end, mode = 'n', desc = 'Take Code Screenshot of visible'
      }
    }
  },
  {
    "coder/claudecode.nvim",
    config = true,
    dependencies = { "folke/snacks.nvim" },
    keys = {
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "snacks_picker_list", "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
      },
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },

  },
  -- {
  --   "carlos-algms/agentic.nvim",
  --   opts = { provider = "claude-agent-acp" },
  --   keys = {
  --     {
  --       "<leader>ac",
  --       function() require("agentic").toggle() end,
  --       mode = { "n", "v" },
  --       desc = "Toggle Agentic Chat"
  --     },
  --     {
  --       "<leader>as",
  --       function() require("agentic").add_selection_or_file_to_context() end,
  --       mode = { "n", "v" },
  --       desc = "Add file or selection to Agentic to Context"
  --     },
  --     {
  --       "<leader>an",
  --       function() require("agentic").new_session() end,
  --       mode = { "n", "v" },
  --       desc = "New Agentic Session"
  --     },
  --     {
  --       "<leader>ar",
  --       function() require("agentic").restore_session() end,
  --       desc = "Agentic Restore session",
  --       silent = true,
  --       mode = { "n", "v" },
  --     },
  --     {
  --       "<leader>ad",
  --       function() require("agentic").add_current_line_diagnostics() end,
  --       desc = "Add current line diagnostic to Agentic",
  --       mode = { "n" },
  --     },
  --     {
  --       "<leader>aD",
  --       function() require("agentic").add_buffer_diagnostics() end,
  --       desc = "Add all buffer diagnostics to Agentic",
  --       mode = { "n" },
  --     },
  --   },
  -- },
  {
    'saghen/blink.cmp',
    version = '1.9.1',
    dependencies = {
      -- { 'dbernheisel/hex-cmp', config = true },
      { 'L3MON4D3/LuaSnip',
        version =  'v2.*',
        config = function() require('dbern.plugins.snippets') end},
    },
    opts_extend = { "sources.default" },
    opts = {
      fuzzy = {
        implementation = 'prefer_rust_with_warning',
      },
      keymap = {
        preset = 'default' ,
        ['<C-e>'] = {},
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
        default = function(_ctx)
          local success, node = pcall(vim.treesitter.get_node)
          if success and node and vim.tbl_contains({ 'comment', 'line_comment', 'block_comment' }, node:type()) then
            return { 'buffer', 'path' }
          else
            return { 'lsp', 'path', 'snippets', 'buffer' }
          end
        end,
        per_filetype = {
          -- elixir = { inherit_defaults = true, 'hex' },
          sql = { 'snippets', 'dadbod', 'buffer' },
        },
        providers = {
          dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
          -- hex = { name = "hex", module = "hex_cmp", async = true }
        },
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
        require('tssorter').sort({})
      end, { nargs = 0 })
    end
  },
  { "cappyzawa/trim.nvim" },
  {
    "folke/snacks.nvim",
    priority = 1000,
    dependencies = {
      { "nvim-tree/nvim-web-devicons", lazy = true },
    },
    lazy = false,
    keys = {
      { "<leader>f", function() Snacks.picker.grep() end, desc = "Find text" },
      { "<leader>S", function() Snacks.scratch() end, desc = "Find text" },
      { "<leader>H", function() Snacks.picker.highlights() end, desc = "Find highlights" },
      { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
      { "<c-s-p>", function() require("dbern.plugins.projects").pick_project() end, desc = "Switch project" },
      { "<c-p>", function()
        Snacks.picker.files({
          exclude = { "@types/" },
          hidden = true,
          matcher = {
            cwd_bonus = true,
            frecency = true,
            sort_empty = true
          }
        })
      end, desc = "Find File" },
      { "<leader>ed", function()
        Snacks.picker.pick("git_files", {
          cwd = os.getenv("HOME"),
          matcher = { frecency = true, sort_empty = true },
          args = { "--git-dir="..os.getenv("HOME").."/.cfg" }
        })
      end, desc = "Find dotfiles" },
      { "<leader>ev", function()
        Snacks.picker.files({
          cwd = "~/.config/nvim",
          matcher = { frecency = true, sort_empty = true },
          exclude = { "undo/" }
        })
      end, desc = "Find neovim file" },
      { "<leader>b", function()
        Snacks.picker.explorer({
          hidden = true,
          auto_close = true,
          follow_file = false,
          watch = false,
        })
      end, desc = "Explore Files" },
      { "<leader>gco", function() Snacks.picker.git_branches() end, desc = "Find git branch" },
      { "<leader>n",  function() Snacks.notifier.show_history() end, desc = "Notification History" },
      { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
      { "]]",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
      { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
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
          keys = {
            { icon = " ", key = "p", desc = "Find File", action = ":lua Snacks.picker.files({ matcher = { cwd_bonus = true, frecency = true, sort_empty = true } })" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ':lua require("fzf-lua").live_grep()' },
            { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          { section = "header" },
          { section = "keys", gap = 0, padding = 1 },
          { icon = " ", title = "Projects", section = "projects", indent = 2, padding = {1, 1} },
          {
            icon = " ",
            desc = "Browse Repo",
            padding = 1,
            key = "b",
            action = function()
              Snacks.gitbrowse()
            end,
          },
          { section = "startup" },
        },
      },
      explorer = {
        replace_netrw = true,
      },
      input = {
        only_scope = true,
        enabled = true
      },
      image = {
        enabled = true,
        -- Only images, not PDFs nor videos
        formats = { "png", "jpg", "jpeg", "gif", "bmp", "webp", "tiff", "heic", "avif" },
      },
      lazygit = {
        enabled = true
      },
      indent = {
        enabled = true,
        animate = { enabled = false },
        only_scope = false,
        only_current = true
      },
      notifier = {
        enabled = true,
        style = "minimal",
        top_down = true,
        filter = function(notification)
          return notification.msg ~= "No information available"
        end
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
        ui_select = true,
        enabled = true,
        sources = {
          files = {
            layout = {
              layout = {
                box = "horizontal",
                width = 0,
                height = 0,
                {
                  box = "vertical",
                  border = true,
                  title = "{title} {live} {flags}",
                  { win = "input", height = 1, border = "bottom" },
                  { win = "list", border = "none" },
                },
                { win = "preview", title = "{preview}", border = true, width = 0.5 },
              },
            },
          },
          grep = {
            layout = {
              layout = {
                box = "horizontal",
                width = 0,
                height = 0,
                {
                  box = "vertical",
                  border = true,
                  title = "{title} {live} {flags}",
                  { win = "input", height = 1, border = "bottom" },
                  { win = "list", border = "none" },
                },
                { win = "preview", title = "{preview}", border = true, width = 0.5 },
              },
            },
            filter = {
              -- Rewrite `!glob` tokens in the search input into
              -- `-- -g !glob` so ripgrep excludes matching paths.
              -- e.g. `!vector/ mix.exs` → `mix.exs -- -g !vector/`
              transform = function(_, filter)
                local terms = {}
                local globs = {}
                for token in filter.search:gmatch('%S+') do
                  if token:sub(1, 1) == '!' and #token > 1 then
                    table.insert(globs, token)
                  else
                    table.insert(terms, token)
                  end
                end
                if #globs > 0 then
                  local glob_args = {}
                  for _, g in ipairs(globs) do
                    table.insert(glob_args, '-g')
                    table.insert(glob_args, g)
                  end
                  filter.search = table.concat(terms, ' ')
                    .. ' -- ' .. table.concat(glob_args, ' ')
                end
              end,
            },
          },
        },
        win = {
          input = {
            keys = {
              ["<Esc>"] = { "close", mode = { "n", "i" } },
            }
          }
        }
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
      -- { "<leader>f", ':call v:lua.fzf_grep()<cr>', silent = true, desc = "Find text" },
      -- { "<c-p>", ':call v:lua.fzf_files()<cr>', desc = "Find file" },
      -- { "<leader>ev", ':call v:lua.fzf_vimrc()<cr>', desc = "Find vimrc file" },
      -- { "<leader>ed", ':call v:lua.fzf_dotfiles()<cr>', desc = "Find dotfile" },
      -- { "<leader>el", ':call v:lua.fzf_local()<cr>', desc = "Find local file" },
      -- { "<leader>gco", ':call v:lua.fzf_git_branches()<cr>', desc = "Find git branch" },
    },
  },
  { 'junegunn/fzf.vim' },
  -- Treesitter
  { 'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    branch = 'main',
    lazy = false,
    opts = {
      install_dir = vim.fn.stdpath('data') .. '/site'
    },
    config = function(_, opts)
      require("vim.treesitter.query").add_predicate("is-mise?", function(_, _, bufnr, _)
        local filepath = vim.api.nvim_buf_get_name(tonumber(bufnr) or 0)
        local filename = vim.fn.fnamemodify(filepath, ":t")
        return string.match(filename, ".*mise.*%.toml$") ~= nil
      end, { force = true, all = false })

      local ts = require('nvim-treesitter')
      local languages = {
        'bash', 'caddy', 'css', 'dart', 'erlang', 'elixir', 'go', 'eex',
        'heex', 'html', 'graphql', 'sql', 'javascript', 'json5', 'kotlin',
        'git_config', 'gitattributes', 'gitcommit', 'gitignore', 'git_rebase',
        'gleam', 'diff', 'make', 'swift', 'scheme', 'ssh_config', 'toml', 'http',
        'lua', 'markdown', 'markdown_inline', 'php', 'python', 'regex', 'ruby',
        'rust', 'scss', 'surface', 'svelte', 'toml', 'tsx', 'typescript',
        'vue', 'yaml', 'zig', 'mermaid', 'query', 'kdl', 'ini'
      }

      ts.install(languages)

      vim.api.nvim_create_autocmd('FileType', {
        pattern = languages,
        callback = function()
          vim.treesitter.start()
          -- vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
          -- vim.wo[0][0].foldmethod = 'expr'
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })

      -- ts.setup(opts)
      vim.treesitter.language.register("bash", "sh")
      vim.treesitter.language.register("bash", "zsh")
      vim.treesitter.language.register("bash", "env")
    end,
  },

  -- Render markdown (including LSP hover floats) with styled headings,
  -- bold/italic, lists, code blocks, tables, rules, etc.
  { 'OXY2DEV/markview.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      { 'nvim-tree/nvim-web-devicons', lazy = true },
    },
    ft = { 'markdown' },
    -- Also load on LspAttach so the first hover in a non-markdown buffer
    -- gets decorated. Neovim sets ft=markdown on the hover float
    -- automatically, which is what markview keys off of.
    event = 'LspAttach',
    config = function()
      require('markview').setup({
        markdown = {
          list_items = {
            shift_width = 1,
            indent_size = 2,
            add_padding = false,
          },
        },
        markdown_inline = {
          -- Markview conceals inline code backticks but by default pads
          -- each side with a virt-text space — so the column width of
          -- "`foo`" stays the same, just shifted. Empty strings collapse
          -- the padding so inline code flows like plain text.
          inline_codes = {
            padding_left = '',
            padding_right = '',
          },
        },
        preview = {
          filetypes = { 'markdown' },
          -- markview defaults to ignoring `nofile` buffers — but LSP hover
          -- floats *are* `nofile`, and rendering them is the whole point.
          -- Override by passing an empty list so no buftype is ignored.
          ignore_buftypes = {},
          -- Hybrid mode reveals raw source around the cursor (markview's
          -- analogue to render-markdown's anti_conceal). Disabled so
          -- previews stay fully rendered in hover floats and regular files.
          hybrid_modes = {},
        },
        -- LaTeX rendering pulls in tree-sitter LaTeX queries we don't need.
        latex = { enable = false },
      })

      -- Markview has no per-buftype sign toggle, so suppress the sign
      -- column for markdown in nofile buffers (LSP hover floats). Signs
      -- the plugin would otherwise place — heading icons, list bullets,
      -- code block indicators — simply have no column to render into.
      -- Regular markdown files keep their sign decorations.
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('markview-nofile-no-signs', {}),
        pattern = 'markdown',
        callback = function(args)
          if vim.bo[args.buf].buftype == 'nofile' then
            vim.wo.signcolumn = 'no'
            vim.wo.spell = false
          end
        end,
      })

      -- Strip the background on fenced-code-block content. Markview
      -- applies `MarkviewCode` (its own hl group) for the block
      -- background; `MarkviewCodeInfo` is the language-label strip at
      -- the top of the block. Both read as noisy stripes inside hover
      -- floats — especially for multi-line blocks. Re-applied on
      -- ColorScheme so scheme switches don't bring the bg back.
      local function clear_code_bg()
        for _, group in ipairs({
          'MarkviewCode',
          'MarkviewCodeInfo',
          'MarkviewInlineCode',
        }) do
          vim.api.nvim_set_hl(0, group, { bg = 'NONE', ctermbg = 'NONE' })
        end
        -- Bold the heading text. `MarkviewHeading<N>` is a *link* to
        -- `MarkviewPalette<N>` (where the actual fg color lives), so
        -- neither `:highlight gui=bold` nor `nvim_set_hl({bold=true})`
        -- works cleanly — both break the link and leave you either
        -- without fg or without bold. We resolve the palette color
        -- ourselves and redefine the heading group with both.
        for i = 1, 6 do
          local palette = vim.api.nvim_get_hl(0, {
            name = 'MarkviewPalette' .. i,
            link = false,
          })
          -- Copy *all* palette attributes (fg, bg, sp, italic,
          -- underline, etc.) and add bold. Copying just `fg` earlier
          -- stripped markview's heading background, which is what
          -- produced the heading color strip — without it, headings
          -- looked plain apart from bold.
          palette.bold = true
          vim.api.nvim_set_hl(0, 'MarkviewHeading' .. i, palette)
        end
      end
      vim.api.nvim_create_autocmd('ColorScheme', {
        group = vim.api.nvim_create_augroup('markview-code-bg-transparent', {}),
        callback = clear_code_bg,
      })
      clear_code_bg()
    end,
  },

  -- Terminal
  { 'numToStr/FTerm.nvim',
    init = function() require('dbern.plugins.fterm').setup() end },

  { 'catgoose/nvim-colorizer.lua',
    event = "BufReadPre",
    opts = {},
  },

  -- Search and Replace
  { 'windwp/nvim-spectre',
    lazy = true,
    cmd = { 'Spectre' },
    build = 'make build-oxi',
    keys = {
      { '<leader>sr', function() require('spectre').open() end, desc = "Find/Replace" },
      { '<leder>srw', function() require('spectre').open_visual() end, desc = "Find/Replace Word", mode = { "n", "v" } },
      { '<leader>sp', function() require('spectre').open_file_search() end, desc = "Find/Replace in Buffer" },

    },
    opts = {
      default = {
        replace = {
          cmd = "oxi"
        }
      }
    }
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
      -- { "<leader>n", "<cmd>Grapple cycle_tags next<cr>", desc = "Grapple cycle next tag" },
      -- { "<leader>p", "<cmd>Grapple cycle_tags prev<cr>", desc = "Grapple cycle previous tag" },
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

  -- Git
  { 'mhinz/vim-signify' },
  {
    "esmuellert/codediff.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    cmd = "CodeDiff",
  },
  { 'FabijanZulj/blame.nvim',
    lazy = true,
    cmd = {'BlameToggle'},
    config = function()
      require('blame').setup()
      vim.cmd([[cnoreabbrev Blame BlameToggle]])
    end,
  },
  { 'pwntester/octo.nvim',
    lazy = true,
    cmd = {"Octo"},
    dependencies = {
      'nvim-lua/plenary.nvim',
      'folke/snacks.nvim',
      { "nvim-tree/nvim-web-devicons", lazy = true }
    },
    opts = {
      suppress_missing_scope = {
        projects_v2 = true,
      },
      picker = "snacks",
    },
  },

  -- Resize panes with C-e and hjkl and arrows
  { 'mrjones2014/smart-splits.nvim',
    version = '>=1.0.0',
    opts = {
      ignored_filetypes = { 'NvimTree', 'snacks_picker_list' },
    },
    keys = {
      -- Resize with arrows
      { '<C-e>k', function() require('smart-splits').resize_up() end, desc = 'Resize split up' },
      { '<C-e>j', function() require('smart-splits').resize_down() end, desc = 'Resize split down' },
      { '<C-e>h', function() require('smart-splits').resize_left() end, desc = 'Resize split left' },
      { '<C-e>l', function() require('smart-splits').resize_right() end, desc = 'Resize split right' },
    }
  },

  -- Add test commands
  { "vim-test/vim-test",
    config = function() require('dbern.plugins.test').setup() end,
    keys = {
      { '<leader>tt', ':TestNearest<cr>', desc = "Test Nearest" },
      { '<leader>tf', ':TestFile<cr>', desc = "Test File" },
      { '<leader>tl', ':TestLast<cr>', desc = "Test Last" },
      { '<leader>ta', ':call v:lua.run_test_suite()<cr>', desc = "Test All" },
    },
  },

  -- Convenience
  { 'tpope/vim-repeat' },
  { 'echasnovski/mini.surround',
    version = '*',
    main = 'mini.git',
    config = function() require('mini.surround').setup({}) end },
  { 'echasnovski/mini.ai',
    version = '*',
    main = 'mini.git',
    config = function() require('mini.ai').setup({}) end },
  { 'echasnovski/mini.splitjoin',
    version = '*',
    main = 'mini.git',
    config = function() require('mini.splitjoin') end },
  { 'echasnovski/mini.trailspace',
    version = '*',
    main = 'mini.git',
    config = function()
      vim.api.nvim_create_autocmd({'BufWritePre'}, {
        group = vim.api.nvim_create_augroup('Trim', {}),
        callback = function(event)
          -- Only trimming if an LSP is attached
          if not vim.tbl_isempty(vim.lsp.get_clients({ bufnr = event.buf })) then
            local ts = require('mini.trailspace')
            ts.trim()
            ts.trim_last_lines()
          end
        end
      })
    end },
  { 'tpope/vim-eunuch' },
  { 'tpope/vim-projectionist' },
  { 'pbrisbin/vim-mkdir' },


  -- { 'nvim-flutter/flutter-tools.nvim',
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --   },
  --   opts = {
  --     flutter_path = nil,
  --     flutter_lookup_cmd = "mise where flutter",
  --     widget_guides = {
  --       enabled = true,
  --     },
  --       closing_tags = {
  --         highlight = "Comment",
  --         prefix = "// ",
  --         enabled = true,
  --       },
  --       dev_log = {
  --         enabled = true,
  --         open_cmd = "tabedit",
  --       },
  --   },
  --   keys = {
  --     { "<leader>fs", ":FlutterRun<CR>", desc = "Flutter Run" },
  --     { "<leader>fq", ":FlutterQuit<CR>", desc = "Flutter Quit" },
  --     { "<leader>fd", ":FlutterDevices<CR>", desc = "Flutter Devices" },
  --     { "<leader>fe", ":FlutterEmulators<CR>", desc = "Flutter Emulators" },
  --     { "<leader>fr", ":FlutterReload<CR>", desc = "Flutter Reload" },
  --     { "<leader>fR", ":FlutterRestart<CR>", desc = "Flutter Restart" },
  --     { "<leader>fD", ":FlutterDevTools<CR>", desc = "Flutter DevTools" },
  --   }
  -- },

  -- Write better
  { 'godlygeek/tabular' },
  { 'reedes/vim-colors-pencil' },
  { 'reedes/vim-pencil' },
  { 'junegunn/limelight.vim' },
  {
    "folke/twilight.nvim",
    opts = {
      dimming = {
        alpha = 0.50, -- amount of dimming
        color = { "Normal", "#ffffff" },
        term_bg = "#000000", -- if guibg=NONE, this will be used to calculate text color
        inactive = false, -- when true, other windows will be fully dimmed (unless they contain the same buffer)
      },
    },
  },
  { "folke/zen-mode.nvim",
    opts = {
      plugins = {
        options = {
          enabled = true,
          ruler = false, -- disables the ruler text in the cmd line area
          showcmd = false, -- disables the command in the last line of the screen
          laststatus = 0, -- turn off the statusline in zen mode
        },
        twilight = { enabled = true }, -- enable to start Twilight when zen mode opens
        gitsigns = { enabled = true }, -- disables git signs
      },
      window = {
        width = 80,
        options = {
          signcolumn = "no", -- disable signcolumn
          number = false, -- disable number column
          relativenumber = false, -- disable relative numbers
          cursorline = false, -- disable cursorline
          cursorcolumn = false, -- disable cursor column
          foldcolumn = "0", -- disable fold column
          list = false, -- disable whitespace characters
        },
      }
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  },
  { 'reedes/vim-wordy' },
}, {
  rocks = {
    hererocks = true,
  },
})
