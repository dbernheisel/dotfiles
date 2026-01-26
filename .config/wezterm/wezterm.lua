local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Preferences
config.hide_mouse_cursor_when_typing = true
config.window_close_confirmation = "NeverPrompt"

-- Keybinds
config.keys = {
	{ key = "Enter", mods = "SHIFT", action = wezterm.action.SendString("\n") },
}

-- macOS Appearance
config.macos_window_background_blur = 32
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.native_macos_fullscreen_mode = true

-- Window
config.window_padding = {
	left = 8,
	right = 8,
	top = 8,
	bottom = 8,
}

-- Font
config.font_size = 16
config.font = wezterm.font_with_fallback({
	{
		family = "Maple Mono",
		weight = "Regular",
		harfbuzz_features = {
			"zero=1", -- 0 with a dot
      "cv01=1",
      "cv02=1",
      "cv09=1",
      "cv10=1",
      "cv31=1",
      "cv32=1",
      "cv33=1",
      "cv34=1",
      "cv35=1",
      "cv36=1",
      "cv37=1",
      "cv42=1",
      "cv43=1",
      "cv61=1",
      "cv64=1",
      "cv66=1",
      "ss05=1",
      "ss06=1",
      "ss07=1",
      "ss08=1"
		},
	},
	{
		family = "FiraCode Nerd Font Mono",
		weight = "Regular",
		harfbuzz_features = {
			"zero=1", -- 0 with a dot
			"cv01=1", -- Normalize special symbols @ $ & % Q => ->
			"cv02=1", -- Alternative a with top arm
			"ss06=1", -- Break connected strokes between italic letters al, il, ull
		},
	},
	{ family = "JetBrainsMono Nerd Font Mono" },
})

config.font_rules = {
	{
		italic = true,
		font = wezterm.font_with_fallback({
			{ family = "Maple Mono", style = "Italic" },
			{ family = "JetBrainsMono Nerd Font Mono", style = "Italic" },
		}),
	},
	{
		intensity = "Bold",
		italic = true,
		font = wezterm.font_with_fallback({
			{ family = "Maple Mono", weight = "Bold", style = "Italic" },
			{ family = "JetBrainsMono Nerd Font Mono", weight = "Bold", style = "Italic" },
		}),
	},
}

config.color_scheme = 'Moonfly (Gogh)'

-- Background opacity with blur
config.window_background_opacity = 0.90

-- Bold is not bright
config.bold_brightens_ansi_colors = false

return config
