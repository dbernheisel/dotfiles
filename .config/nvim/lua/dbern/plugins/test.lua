local terminal = require('dbern.plugins.fterm')
local U = require("dbern.utils")
local M = {}

M.monorepo = nil
M.monorepos = {
  ["dscout"] = {
    setup = function()
      -- Dendra is too complex for vim-test, has its own runner
      vim.g["test#javascript#runner"] = "dendra"
      -- Overriding since built-in vim-test detection fails due to monorepo
      vim.g["test#elixir#exunit#executable"] = "mix test"
      vim.g["test#custom_runners"] = {
        ["JavaScript"] = {'dendra'},
      }
      vim.g["test#ruby#rspec#executable"] = "bundle exec rspec"
      vim.g["test#ruby#use_binstubs"] = 0
      vim.g["test#ruby#bundle_exec"] = 1

      _G.TestFindRoot = function()
        local roots = {
          vim.fs.root(0, "mix.exs"),
          vim.fs.root(0, "package.json"),
          vim.fs.root(0, "Gemfile"),
          vim.fs.root(0, "poetry.toml")
        }
        for _, root in pairs(roots) do
          if root ~= nil then
            return root
          end
        end

        return vim.uv.cwd()
      end


      _G.test_monorepo = function(cmd)
        -- If in Monorepo
        if M.monorepo then
          local app_config = M.monorepo.app_config(cmd) or {}

          if type(app_config.placeholders) == "table" then
            for placeholder, func in pairs(app_config.placeholders) do
              cmd = string.gsub(cmd, placeholder, func(cmd))
            end
          end

          if M.monorepo.run_in_container then
            terminal.run_cmd({
              app_config.reset_container_cmd,
              app_config.enter_container_cmd
            })
          else
            if app_config.host_cmd ~= nil then
              cmd = app_config.host_cmd.." "..cmd
            end
          end
        end

        return cmd
      end

      vim.g["test#transformation"] = 'monorepo'
      vim.g["test#custom_transformations"] = { ["monorepo"] = _G.test_monorepo }
      vim.g["test#project_root"] = _G.TestFindRoot
    end,
    run_in_container = true,
    app_config = function(cmd)
      if cmd:find("poetry") then
        return {
          host_cmd = "../../bin/astro",
          reset_container_cmd = "[[ $INDOCKER == 'true' && $HOSTNAME != 'astro' ]] && exit",
          enter_container_cmd = "[[ $INDOCKER != 'true' ]] && ../../bin/astro zsh",
        }
      end

      if cmd:find("mix test") then
        return {
          host_cmd = "../../bin/axon",
          reset_container_cmd = "[[ $INDOCKER == 'true' && $HOSTNAME != 'axon' ]] && exit",
          enter_container_cmd = "[[ $INDOCKER != 'true' ]] && ../../bin/axon zsh",
        }
      end

      if cmd:find("karma") then
        return {
          host_cmd = "../../bin/dendra",
          reset_container_cmd = "[[ $INDOCKER == 'true' && $HOSTNAME != 'dendra' ]] && exit",
          enter_container_cmd = "[[ $INDOCKER != 'true' ]] && ../../bin/dendra zsh",
          placeholders = {
            ["{CONFIG}"] = function(test_cmd)
              if string.find(test_cmd, "_test%.") then
                return "karma.enzyme.conf.js"
              else
                return "karma.conf.js"
              end
            end
          }
        }
      end

      if cmd:find("rspec") then
        return {
          reset_container_cmd = "[[ $INDOCKER == 'true' && $HOSTNAME != 'soma' ]] && exit",
          enter_container_cmd = "[[ $INDOCKER != 'true' ]] && ../../bin/soma zsh",
          host_cmd = "../../bin/soma",
        }
      end

      return nil
    end
  }
}

_G.test_fterm = function(cmd)
  terminal.run_cmd(cmd)
end

_G.run_test_suite = function()
  if vim.fn.filereadable('bin/test') == 1 then
    terminal.run_cmd('bin/test')
  else
    vim.cmd('TestSuite')
  end
end

M.setup = function()
  vim.g["test#custom_strategies"] = { ["FTerm"] = _G.test_fterm }
  vim.g["test#shell#bats#options"] = { ["nearest"] = "-t" }

  if U.is_kitty() then
    vim.g["test#plugin_path"] = vim.fn.fnamemodify("~/.config/kitty", ":p:h")
    vim.g["test#strategy"] = "kitty"
  else
    vim.g["test#strategy"] = "FTerm"
  end

  local git = vim.system({"git", "config", "--get", "remote.origin.url"}, { text = true }):wait()

  if git.code == 0 then
    local repo = vim.fs.basename(git.stdout:gsub(".git\n", ""))
    local config = M.monorepos[repo]
    if type(config) == "table" then
      if type(config.setup) == "function" then config.setup() end
      M.monorepo = config
    end
  end
end

return M
