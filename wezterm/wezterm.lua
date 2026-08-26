-- wezterm.lua — SOLO ASPECTO
--
-- Este archivo es deliberadamente mínimo y desechable: es la única parte de la
-- configuración que NO es portable (un emulador no existe en un servidor).
-- Todo el comportamiento —splits, navegación, sesiones, copiado— vive en
-- ~/.config/tmux/tmux.conf, que sí viaja a todas las máquinas.
--
-- Portar esto a Ghostty/Kitty/Alacritty son 5 minutos: son 6 ajustes.

local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Tipografía
config.font = wezterm.font("RecMonoLinear Nerd Font Mono")
config.font_size = 24.0
config.line_height = 1.25

-- Color y fondo
config.color_scheme = "Tokio Night"
config.window_background_opacity = 1
config.background = {
	{
		source = { Color = "#02051F" },
		width = "100%",
		height = "100%",
		opacity = 0.75,
	},
}

-- Cromo de la ventana (lo mínimo para que no estorbe)
config.enable_tab_bar = false -- la barra de tmux hace este trabajo
config.window_decorations = "RESIZE"
config.window_close_confirmation = "NeverPrompt"

return config
