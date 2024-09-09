local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.automatically_reload_config = true

config.color_scheme = "Everforest Dark (Gogh)"
config.window_background_opacity = 0.96
config.font = wezterm.font("HackGen35 Console NF", { weight = "Regular", stretch = "Normal", style = "Normal" })
config.font_size = 16
config.audible_bell = "Disabled"

return config
