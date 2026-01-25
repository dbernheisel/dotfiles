local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Shell
config.default_prog = { "/bin/zsh" }

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
		family = "Maple Mono NF",
		weight = "Regular",
		harfbuzz_features = {
			"zero=1", -- 0 with a dot
			"cv01=1", -- Normalize special symbols @ $ & % Q => ->
			"cv02=1", -- Alternative a with top arm
			"ss06=1", -- Break connected strokes between italic letters al, il, ull
		},
	},
	{ family = "FiraCode Nerd Font Mono" },
	{ family = "JetBrainsMono Nerd Font Mono" },
})
config.font_rules = {
	{
		italic = true,
		font = wezterm.font_with_fallback({
			{ family = "Maple Mono NF", style = "Italic" },
			{ family = "JetBrainsMono Nerd Font Mono", style = "Italic" },
		}),
	},
	{
		intensity = "Bold",
		italic = true,
		font = wezterm.font_with_fallback({
			{ family = "Maple Mono NF", weight = "Bold", style = "Italic" },
			{ family = "JetBrainsMono Nerd Font Mono", weight = "Bold", style = "Italic" },
		}),
	},
}

-- Theme - Moonfly (dark)
local moonfly = {
	foreground = "#bdbdbd",
	background = "#080808",
	cursor_fg = "#080808",
	cursor_bg = "#8e8e8e",
	selection_fg = "#080808",
	selection_bg = "#b2ceee",
	ansi = {
		"#323437", -- black
		"#ff5d5d", -- red
		"#8cc85f", -- green
		"#e3c78a", -- yellow
		"#80a0ff", -- blue
		"#cf87e8", -- magenta
		"#79dac8", -- cyan
		"#c6c6c6", -- white
	},
	brights = {
		"#949494", -- bright black
		"#ff5189", -- bright red
		"#36c692", -- bright green
		"#c6c684", -- bright yellow
		"#74b2ff", -- bright blue
		"#ae81ff", -- bright magenta
		"#85dc85", -- bright cyan
		"#e4e4e4", -- bright white
	},
}

-- Theme - Ayu Light
local ayu_light = {
	foreground = "#5c6166",
	background = "#f8f9fa",
	cursor_fg = "#f8f9fa",
	cursor_bg = "#5c6166",
	selection_fg = "#5c6166",
	selection_bg = "#d3e1f5",
	ansi = {
		"#000000", -- black
		"#ea6c6d", -- red
		"#6cbf43", -- green
		"#eca944", -- yellow
		"#3199e1", -- blue
		"#9e75c7", -- magenta
		"#46ba94", -- cyan
		"#c7c7c7", -- white
	},
	brights = {
		"#686868", -- bright black
		"#f07171", -- bright red
		"#86b300", -- bright green
		"#f2ae49", -- bright yellow
		"#399ee6", -- bright blue
		"#a37acc", -- bright magenta
		"#4cbf99", -- bright cyan
		"#d1d1d1", -- bright white
	},
}

-- Auto-detect dark/light mode
local function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return moonfly
	else
		return ayu_light
	end
end

config.colors = scheme_for_appearance(wezterm.gui.get_appearance())

-- Background opacity with blur
config.window_background_opacity = 0.90

-- Bold is not bright
config.bold_brightens_ansi_colors = false

-- vi: ft=lua
