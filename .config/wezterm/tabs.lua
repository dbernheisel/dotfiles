local wezterm = require("wezterm") --[[@as Wezterm]]
local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")

local M = {}

local scheme = wezterm.color.get_builtin_schemes()['Moonfly (Gogh)']
local tab_active_fg = scheme.ansi[5]
local tab_active_bg = scheme.cursor and scheme.cursor.bg or scheme.ansi[1]

local TAB_MAX_TITLE = 24

local function truncate(s)
  if #s > TAB_MAX_TITLE then
    return s:sub(1, TAB_MAX_TITLE - 1) .. ' ' .. wezterm.nerdfonts.cod_ellipsis
  end
  return s
end

local function tab_title(tab)
  local session = tab.active_pane.user_vars.zellij_session

  if session and session ~= '' then
    return ' ' .. truncate(tab.active_pane.title or session) .. ' '
  end

  local proc = tab.active_pane.foreground_process_name or ''
  proc = proc:match('([^/]+)$') or proc
  if proc == 'zsh' or proc == 'bash' or proc == '' then
    local cwd_uri = tab.active_pane.current_working_dir
    if cwd_uri then
      return ' ' .. truncate(cwd_uri.file_path:match('([^/]+)/?$') or proc) .. ' '
    end
  end

  return ' ' .. truncate(proc) .. ' '
end

---@param config Config
function M.setup(config)
  config.unzoom_on_switch_pane = true
  config.tab_bar_at_bottom = false

  tabline.setup({
    options = {
      icons_enabled = true,
      theme = 'Moonfly (Gogh)',
      section_separators = {
        left = wezterm.nerdfonts.pl_left_hard_divider,
        right = wezterm.nerdfonts.pl_right_hard_divider,
      },
      component_separators = {
        left = wezterm.nerdfonts.pl_left_soft_divider,
        right = wezterm.nerdfonts.pl_right_soft_divider,
      },
      tab_separators = {
        left = '',
        right = '',
      },
      theme_overrides = {
        tab = {
          active = { fg = tab_active_bg, bg = tab_active_fg },
        },
      },
    },
    sections = {
      tabline_a = {
        {
          'mode',
          cond = function(window)
            return window:active_key_table() ~= nil
          end,
        },
      },
      tabline_b = {},
      tabline_c = {},
      tab_active = {
        { Attribute = { Intensity = 'Bold' } },
        'index',
        'ResetAttributes',
        { Foreground = { Color = tab_active_fg } },
        { Background = { Color = tab_active_bg } },
        tab_title,
        { 'zoomed', padding = 0 },
      },
      tab_inactive = {
        { Attribute = { Intensity = 'Bold' } },
        { Attribute = { Reverse = true } },
        'index',
        'ResetAttributes',
        { Attribute = { Reverse = false } },
        tab_title,
      },
      tabline_x = {},
      tabline_y = {},
      tabline_z = {
        {
          'battery',
          cond = function()
            local info = wezterm.battery_info()
            if info and #info > 0 then
              return info[1].state ~= "Charging" and info[1].state ~= "Full"
            end
            return false
          end,
        },
      },
    },
    extensions = {},
  })

  tabline.apply_to_config(config)
end

return M
