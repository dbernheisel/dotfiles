local wezterm = require("wezterm")  --[[@as Wezterm]]
local config = wezterm.config_builder()

require("tabs").setup(config)
require("mouse").setup(config)
require("links").setup(config)
require("fonts").setup(config)
require("keys").setup(config)

config.hide_mouse_cursor_when_typing = true
config.window_close_confirmation = "NeverPrompt"
config.color_scheme = 'Moonfly (Gogh)'
config.bold_brightens_ansi_colors = false
config.underline_thickness = 3
config.cursor_thickness = 4
config.underline_position = -6
config.default_cursor_style = "BlinkingBar"
config.enable_kitty_graphics = true
config.command_palette_font_size = 13
config.command_palette_bg_color = "#394b70"
config.command_palette_fg_color = "#828bb8"

if wezterm.target_triple == 'x86_64-unknown-linux-gnu' then
  config.window_decorations = "TITLE|RESIZE"
  config.enable_wayland = true
  config.window_background_opacity = 0.95
end

-- macOS Appearance
if wezterm.target_triple == 'aarch64-apple-darwin' then
  config.macos_window_background_blur = 32
  config.window_decorations = "RESIZE"
  config.native_macos_fullscreen_mode = true
  config.window_background_opacity = 0.90
end

-- Window
config.window_padding = {
  left = 8,
  right = 8,
  top = 8,
  bottom = 8,
}

return config
