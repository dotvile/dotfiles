local wezterm = require("wezterm")

local config = wezterm.config_builder()
local action = wezterm.action

local mods = "CTRL | ALT"

config = {

	window_background_opacity = 1,
	enable_tab_bar = false,
	inactive_pane_hsb = {
		saturation = 0.75,
		brightness = 0.45,
	},
	automatically_reload_config = true,
	window_close_confirmation = "NeverPrompt",
	window_decorations = "RESIZE",
	background = {
		{
			source = {
				Color = "#02051F",
			},
			width = "100%",
			height = "100%",
			opacity = 0.75,
		},
	},
	color_scheme = "Tokio Night",
	font = wezterm.font("RecMonoLinear Nerd Font Mono"),
	font_size = 24.0,
	line_height = 1.25,

	-- leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 },
	keys = {
		-- Pane config
		{ key = "v", mods = mods, action = action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
		{ key = "z", mods = mods, action = action.SplitVertical({ domain = "CurrentPaneDomain" }) },
		{ key = "h", mods = mods, action = action.ActivatePaneDirection("Left") },
		{ key = "t", mods = mods, action = action.ActivatePaneDirection("Down") },
		{ key = "n", mods = mods, action = action.ActivatePaneDirection("Up") },
		{ key = "s", mods = mods, action = action.ActivatePaneDirection("Right") },
		{ key = "w", mods = mods, action = action.CloseCurrentPane({ confirm = true }) },
	},
}
return config
