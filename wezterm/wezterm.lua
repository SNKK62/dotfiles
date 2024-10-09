local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.automatically_reload_config = true

config.color_scheme = "Catppuccin Mocha"
local colors = {
	catppuccin = {
		mocha = {
			background = "#1e1e2e",
			text = "#cdd6f4",
			selected = "#eba0ac",
		},
	},
}

config.window_background_opacity = 0.92
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
config.show_close_tab_button_in_tabs = false
config.use_fancy_tab_bar = true

config.window_background_gradient = {
	colors = { colors.catppuccin.mocha.background },
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

local act = wezterm.action
config.disable_default_key_bindings = true
config.keys = {
	-- -- move back one word
	{
		key = "h",
		mods = "CTRL|SHIFT",
		action = wezterm.action_callback(function(window, pane)
			window:perform_action(wezterm.action.SendKey({ key = "[", mods = "CTRL" }), pane)
			window:perform_action(wezterm.action.SendKey({ key = "b" }), pane)
		end),
	},
	-- -- move forward one word
	{
		key = "l",
		mods = "CTRL|SHIFT",
		action = wezterm.action_callback(function(window, pane)
			window:perform_action(wezterm.action.SendKey({ key = "[", mods = "CTRL" }), pane)
			window:perform_action(wezterm.action.SendKey({ key = "f" }), pane)
		end),
	},
	-- delete word
	{
		key = "Backspace",
		mods = "CTRL",
		action = act.SendKey({
			key = "w",
			mods = "CTRL",
		}),
	},
	{
		key = "t",
		mods = "SUPER",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = "c",
		mods = "SUPER",
		action = act.CopyTo("Clipboard"),
	},
	{
		key = "v",
		mods = "SUPER",
		action = act.PasteFrom("Clipboard"),
	},
	{
		key = "n",
		mods = "SUPER",
		action = act.SpawnWindow,
	},
	{
		key = "w",
		mods = "SUPER",
		action = act.CloseCurrentTab({ confirm = true }),
	},
	{
		key = "f",
		mods = "SUPER",
		action = act.Search({ CaseSensitiveString = "" }),
	},
	{
		key = "Tab",
		mods = "CTRL",
		action = act.ActivateTabRelative(1),
	},
	{
		key = "Tab",
		mods = "CTRL|SHIFT",
		action = act.ActivateTabRelative(-1),
	},
	{
		key = "Tab",
		mods = "ALT",
		action = act.MoveTabRelative(1),
	},
	{
		key = "Tab",
		mods = "ALT|SHIFT",
		action = act.MoveTabRelative(-1),
	},

	-- activate copy mode
	{ key = "x", mods = "CTRL|SHIFT", action = wezterm.action.ActivateCopyMode },
}

config.key_tables = {
	copy_mode = {
		{
			key = "Enter",
			mods = "NONE",
			action = act.CopyMode("MoveToStartOfNextLine"),
		},
		{
			key = "Escape",
			mods = "NONE",
			action = act.Multiple({
				{ CopyMode = "Close" },
			}),
		},
		{
			key = "c",
			mods = "CTRL",
			action = act.Multiple({
				{ CopyMode = "Close" },
			}),
		},
		{
			key = "$",
			mods = "NONE",
			action = act.CopyMode("MoveToEndOfLineContent"),
		},
		{ key = "0", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
		{
			key = "^",
			mods = "NONE",
			action = act.CopyMode("MoveToStartOfLineContent"),
		},
		{ key = "b", mods = "NONE", action = act.CopyMode("MoveBackwardWord") },
		{
			key = "LeftArrow",
			mods = "NONE",
			action = act.CopyMode("MoveBackwardWord"),
		},
		{
			key = "d",
			mods = "CTRL",
			action = act.CopyMode({ MoveByPage = 0.5 }),
		},
		{
			key = "e",
			mods = "NONE",
			action = act.CopyMode("MoveForwardWordEnd"),
		},
		{
			key = "f",
			mods = "NONE",
			action = act.CopyMode({ JumpForward = { prev_char = false } }),
		},
		{ key = "h", mods = "NONE", action = act.CopyMode("MoveLeft") },
		{ key = "j", mods = "NONE", action = act.CopyMode("MoveDown") },
		{ key = "k", mods = "NONE", action = act.CopyMode("MoveUp") },
		{ key = "l", mods = "NONE", action = act.CopyMode("MoveRight") },
		{
			key = "q",
			mods = "NONE",
			action = act.Multiple({
				{ CopyMode = "Close" },
			}),
		},
		{
			key = "t",
			mods = "NONE",
			action = act.CopyMode({ JumpForward = { prev_char = true } }),
		},
		{
			key = "u",
			mods = "CTRL",
			action = act.CopyMode({ MoveByPage = -0.5 }),
		},
		{
			key = "v",
			mods = "NONE",
			action = act.CopyMode({ SetSelectionMode = "Cell" }),
		},
		{
			key = "v",
			mods = "SHIFT",
			action = act.CopyMode({ SetSelectionMode = "Line" }),
		},
		{
			key = "v",
			mods = "CTRL",
			action = act.CopyMode({ SetSelectionMode = "Block" }),
		},
		{ key = "w", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
		{
			key = "RightArrow",
			mods = "NONE",
			action = act.CopyMode("MoveForwardWord"),
		},
		{
			key = "y",
			mods = "NONE",
			action = act.Multiple({
				act.CopyTo("PrimarySelection"),
				act.ClearSelection,
				-- clear the selection mode, but remain in copy mode
				act.CopyMode("ClearSelectionMode"),
			}),
		},
		{ key = "UpArrow", mods = "NONE", action = act.CopyMode("MoveUp") },
		{ key = "DownArrow", mods = "NONE", action = act.CopyMode("MoveDown") },
	},
}

return config
