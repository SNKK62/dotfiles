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
		mods = "SHIFT",
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
