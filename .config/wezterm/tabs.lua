local wezterm = require("wezterm")  --[[@as Wezterm]]

local M = {}

M.arrow_solid = ""
M.arrow_thin = ""
M.icons = {
  ["mix"] = wezterm.nerdfonts.seti_elixir,
  ["elixir"] = wezterm.nerdfonts.seti_elixir,
  ["elixirc"] = wezterm.nerdfonts.seti_elixir,
  ["iex"] = wezterm.nerdfonts.seti_elixir,
  ["bash"] = wezterm.nerdfonts.cod_terminal_bash,
  ["cargo"] = wezterm.nerdfonts.dev_rust,
  ["docker"] = wezterm.nerdfonts.linux_docker,
  ["docker-compose"] = wezterm.nerdfonts.linux_docker,
  ["gh"] = wezterm.nerdfonts.dev_github_badge,
  ["git"] = wezterm.nerdfonts.dev_git,
  ["lazygit"] = wezterm.nerdfonts.cod_github,
  ["go"] = wezterm.nerdfonts.seti_go,
  ["htop"] = wezterm.nerdfonts.md_chart_areaspline,
  ["btop"] = wezterm.nerdfonts.md_chart_areaspline,
  ["kubectl"] = wezterm.nerdfonts.linux_docker,
  ["lua"] = wezterm.nerdfonts.seti_lua,
  ["make"] = wezterm.nerdfonts.seti_makefile,
  ["node"] = wezterm.nerdfonts.fa_node_js,
  ["psql"] = wezterm.nerdfonts.dev_postgresql,
  ["ruby"] = wezterm.nerdfonts.cod_ruby,
  ["sudo"] = wezterm.nerdfonts.fa_hashtag,
  ["vim"] = wezterm.nerdfonts.linux_neovim,
  ["wget"] = wezterm.nerdfonts.mdi_arrow_down_box,
  ["curl"] = wezterm.nerdfonts.md_arrow_down_box,
  ["nvim"] = wezterm.nerdfonts.linux_neovim,
  ["zsh"] = wezterm.nerdfonts.dev_terminal,
}

---@param tab MuxTabObj
---@param max_width number
function M.title(tab, max_width)
  local title = (tab.tab_title and #tab.tab_title > 0) and tab.tab_title or tab.active_pane.title
  local process, other = title:match("^(%S+)%s*%-?%s*%s*(.*)$")

  if M.icons[process] then
    title = M.icons[process] .. " " .. (other or "")
  end

  local is_zoomed = false
  for _, pane in ipairs(tab.panes) do
    if pane.is_zoomed then
      is_zoomed = true
      break
    end
  end
  if is_zoomed then -- or (#tab.panes > 1 and not tab.is_active) then
    title = " " .. title
  end

  title = wezterm.truncate_right(title, max_width - 3)
  return " " .. title .. " "
end

---@param config Config
function M.setup(config)
  config.use_fancy_tab_bar = false
  config.hide_tab_bar_if_only_one_tab = true
  config.tab_max_width = 32
  config.unzoom_on_switch_pane = true

  wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
      local title = M.title(tab, max_width)

      local tab_idx = 1
      for i, t in ipairs(tabs) do
        if t.tab_id == tab.tab_id then
          tab_idx = i
          break
        end
      end
      local is_last = tab_idx == #tabs
      local next_tab = tabs[tab_idx + 1]
      local next_is_active = next_tab and next_tab.is_active
      local arrow = (tab.is_active or is_last or next_is_active) and M.arrow_solid or M.arrow_thin
      local arrow_bg = inactive_bg

      local ret = tab.is_active
          and {
            { Attribute = { Intensity = "Bold" } },
            { Attribute = { Italic = true } },
          }
        or {}
      ret[#ret + 1] = { Text = title }
      ret[#ret + 1] = { Text = arrow }
      return ret
    end)
end

return M
