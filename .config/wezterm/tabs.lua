local wezterm = require("wezterm") --[[@as Wezterm]]

local M = {}

-- Moonfly-inspired tab colors
local colors = {
  bar_bg = "#121212",
  active_bg = "#2c3043",
  active_fg = "#80a0ff",
  inactive_bg = "#121212",
  inactive_fg = "#6e738d",
  hover_bg = "#1e2132",
  hover_fg = "#a1aab8",
  separator_fg = "#3b3f52",
}

M.arrow_solid = ""
M.arrow_thin = ""
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

  if is_zoomed then
    title = " " .. title
  end

  title = wezterm.truncate_right(title, max_width - 3)
  return " " .. title .. " "
end

---@param config Config
function M.setup(config)
  config.hide_tab_bar_if_only_one_tab = true
  config.use_fancy_tab_bar = false
  config.tab_max_width = 32
  config.unzoom_on_switch_pane = true

  config.colors = config.colors or {}
  config.colors.tab_bar = {
    background = colors.bar_bg,
    new_tab = { bg_color = colors.bar_bg, fg_color = colors.inactive_fg },
    new_tab_hover = { bg_color = colors.hover_bg, fg_color = colors.hover_fg },
  }

  wezterm.on("format-tab-title", function(tab, tabs, panes, cfg, hover, max_width)
    local title = M.title(tab, max_width)

    local bg = tab.is_active and colors.active_bg
      or hover and colors.hover_bg
      or colors.inactive_bg
    local fg = tab.is_active and colors.active_fg
      or hover and colors.hover_fg
      or colors.inactive_fg

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

    -- Solid arrow at edges and active transitions, thin divider between inactive tabs
    local use_solid = tab.is_active or is_last or next_is_active
    local arrow = use_solid and M.arrow_solid or M.arrow_thin

    local edge_bg = colors.bar_bg
    if next_tab then
      edge_bg = next_is_active and colors.active_bg or colors.inactive_bg
    end

    local ret = {}

    if tab.is_active then
      table.insert(ret, { Attribute = { Intensity = "Bold" } })
      table.insert(ret, { Attribute = { Italic = true } })
    end

    table.insert(ret, { Background = { Color = bg } })
    table.insert(ret, { Foreground = { Color = fg } })
    table.insert(ret, { Text = title })

    -- Arrow separator with proper color transitions
    if use_solid then
      table.insert(ret, { Background = { Color = edge_bg } })
      table.insert(ret, { Foreground = { Color = bg } })
    else
      table.insert(ret, { Background = { Color = colors.inactive_bg } })
      table.insert(ret, { Foreground = { Color = colors.separator_fg } })
    end
    table.insert(ret, { Text = arrow })

    return ret
  end)
end

return M
