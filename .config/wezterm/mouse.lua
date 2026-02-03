local wezterm = require("wezterm")

local M = {}

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
  }
end

return M
