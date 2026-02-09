local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

local function smart_wheel(direction)
  return wezterm.action_callback(function(window, pane)
    local vars = pane:get_user_vars()
    if vars.IS_NVIM == 'true' then
      local key = direction < 0 and 'UpArrow' or 'DownArrow'
      for _ = 1, 5 do
        window:perform_action(act.SendKey { key = key }, pane)
      end
    elseif vars.zellij_session then
      local zj = '/opt/homebrew/bin/zellij'
      local zs = vars.zellij_session
      local scroll = direction < 0 and 'half-page-scroll-up' or 'half-page-scroll-down'
      wezterm.run_child_process({ zj, '-s', zs, 'action', 'switch-mode', 'scroll' })
      wezterm.run_child_process({ zj, '-s', zs, 'action', scroll })
    else
      window:perform_action(act.ScrollByLine(direction * 5), pane)
    end
  end)
end

---@param config Config
function M.setup(config)
  config.alternate_buffer_wheel_scroll_speed = 1
  config.mouse_bindings = {
    -- Don't open links without modifier
    {
      event = { Up = { streak = 1, button = "Left" } },
      mods = 'NONE',
      action = wezterm.action.CompleteSelection("ClipboardAndPrimarySelection"),
    },
    {
      event = { Up = { streak = 1, button = "Left" } },
      mods = 'CTRL|SHIFT',
      action = wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor("ClipboardAndPrimarySelection"),
    },
    {
      event = { Down = { streak = 1, button = "Left" } },
      mods = "CTRL|SHIFT",
      action = wezterm.action.Nop,
    },
    {
      event = { Down = { streak = 1, button = { WheelUp = 1 } } },
      mods = 'NONE',
      action = smart_wheel(-1),
    },
    {
      event = { Down = { streak = 1, button = { WheelDown = 1 } } },
      mods = 'NONE',
      action = smart_wheel(1),
    },
  }
end

return M
