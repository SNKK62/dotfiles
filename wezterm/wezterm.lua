local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.automatically_reload_config = true

config.color_scheme = "Catppuccin Mocha"
-- config.color_scheme = "Everforest Dark Soft (Gogh)"
local colors = {
	catppuccin = {
		mocha = {
			background = "#1e1e2e",
			text = "#cdd6f4",
			selected = "#eba0ac",
		},
	},
	everforest = {
		dark = {
			soft = {
				background = "#333c43",
				text = "#cdd6f4",
				selected = "#88c0d0",
			},
		},
	},
}

config.window_background_opacity = 0.88
config.macos_window_background_blur = 50

config.font = wezterm.font("HackGen35 Console NF", { weight = "Regular", stretch = "Normal", style = "Normal" })
config.font_size = 16
config.use_ime = true
config.audible_bell = "Disabled"

-- hide title bar
config.window_decorations = "RESIZE"
-- hide tab bar
config.show_tabs_in_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.show_new_tab_button_in_tab_bar = false
-- config.show_close_tab_button_in_tabs = false
config.use_fancy_tab_bar = true

config.window_background_gradient = {
	colors = { colors.catppuccin.mocha.background },
	-- colors = { colors.everforest.dark.soft.background },
}
config.window_frame = {
	inactive_titlebar_bg = "none",
	active_titlebar_bg = "none",
}
config.colors = {
	tab_bar = {
		inactive_tab_edge = "none",
	},
}

local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle
---@diagnostic disable-next-line: unused-local, redefined-local
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local background = colors.catppuccin.mocha.background
	local foreground = colors.catppuccin.mocha.text
	local edge_background = "none"
	if tab.is_active then
		background = colors.catppuccin.mocha.selected
		foreground = colors.catppuccin.mocha.background
	end
	local edge_foreground = background
	local title = "   " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "
	return {
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_LEFT_ARROW },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = title },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_RIGHT_ARROW },
	}
end)

-- for underline of bufferline in neovim
config.underline_thickness = "2.5px"

-- -@diagnostic disable-next-line: unused-local
-- wezterm.on("update-right-status", function(window, pane)
-- 	local mode = "TABLE:  " .. (window:active_key_table() or "normal")
-- 	local workspace = 'WORKSPACE:  " ' .. window:active_workspace() .. ' "'
-- 	window:set_right_status(mode .. ",  " .. workspace)
-- end)

wezterm.on("tab-closing", function(window, _)
	local workspace = window:active_workspace()
	local tabs_in_current_workspace = window:tabs_for_workspace(workspace)

	if #tabs_in_current_workspace == 1 then
		local all_workspaces = window:workspaces()
		if #all_workspaces > 1 then
			local next_workspace = nil
			for _, ws in ipairs(all_workspaces) do
				if ws ~= workspace then
					next_workspace = ws
					break
				end
			end
			if next_workspace then
				window:set_active_workspace(next_workspace)
			end
			return true
		end
	end
	return true
end)

config.leader = { key = "a", mods = "SUPER", timeout_milliseconds = 2000 }
config.disable_default_key_bindings = true
config.keys = require("keys")
config.key_tables = require("key_tables")
return config
