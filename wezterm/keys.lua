local wezterm = require("wezterm")
local act = wezterm.action
return {
	-- decrease font size
	{
		key = "-",
		mods = "SUPER",
		action = act.DecreaseFontSize,
	},
	-- increase font size
	{
		key = "=",
		mods = "SUPER",
		action = act.IncreaseFontSize,
	},
	-- move back one word
	{
		key = "h",
		mods = "CTRL|SHIFT",
		action = wezterm.action_callback(function(window, pane)
			window:perform_action(act.SendKey({ key = "[", mods = "CTRL" }), pane)
			window:perform_action(act.SendKey({ key = "b" }), pane)
		end),
	},
	-- move forward one word
	{
		key = "l",
		mods = "CTRL|SHIFT",
		action = wezterm.action_callback(function(window, pane)
			window:perform_action(act.SendKey({ key = "[", mods = "CTRL" }), pane)
			window:perform_action(act.SendKey({ key = "f" }), pane)
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
	{ key = "q", mods = "SUPER", action = wezterm.action.QuitApplication },
	{
		key = "f",
		mods = "SUPER",
		action = act.Search({ CaseSensitiveString = "" }),
	},
	{ key = "p", mods = "SUPER", action = act.ActivateCommandPalette },
	{ key = "r", mods = "SUPER", action = act.ReloadConfiguration },
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
	{ key = "v", mods = "LEADER", action = act.ActivateCopyMode },
	-- activate pane mode
	{ key = "p", mods = "LEADER", action = act.ActivateKeyTable({ name = "pane", one_shot = false }) },
	-- activate workspace mode
	{ key = "w", mods = "LEADER", action = act.ActivateKeyTable({ name = "workspace" }) },
}
