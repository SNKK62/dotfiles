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
	{
		key = "LeftArrow",
		mods = "SHIFT",
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
	{
		key = "RightArrow",
		mods = "SHIFT",
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
		key = "t",
		mods = "SUPER|SHIFT",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = "w",
		mods = "SUPER|SHIFT",
		action = act.CloseCurrentTab({ confirm = true }),
	},
	{ key = "d", mods = "SUPER|SHIFT", action = act({ CloseCurrentPane = { confirm = true } }) },
	{ key = "q", mods = "SUPER", action = wezterm.action.QuitApplication },
	{ key = "p", mods = "SUPER", action = act.ActivateCommandPalette },
	{ key = "r", mods = "SUPER", action = act.ReloadConfiguration },
	{ key = "f", mods = "SUPER|CTRL", action = act.ToggleFullScreen },
	{
		key = ";",
		mods = "SUPER",
		action = act.ActivateTabRelative(1),
	},
	{
		key = "'",
		mods = "SUPER",
		action = act.ActivateTabRelative(-1),
	},
	-- workaround for hammerspoon
	{
		key = "LeftArrow",
		mods = "SUPER",
		action = act.SendKey({
			key = "'",
			mods = "CTRL",
		}),
	},
	{
		key = "RightArrow",
		mods = "SUPER",
		action = act.SendKey({
			key = ";",
			mods = "CTRL",
		}),
	},
	-- workaround for zellij
	{
		key = "h",
		mods = "SUPER",
		action = act.SendKey({
			key = "1",
			mods = "ALT",
		}),
	},
	{
		key = "l",
		mods = "SUPER",
		action = act.SendKey({
			key = "2",
			mods = "ALT",
		}),
	},
	{
		key = "j",
		mods = "SUPER",
		action = act.SendKey({
			key = "3",
			mods = "ALT",
		}),
	},
	{
		key = "k",
		mods = "SUPER",
		action = act.SendKey({
			key = "4",
			mods = "ALT",
		}),
	},
	{
		key = "h",
		mods = "SUPER|SHIFT",
		action = act.SendKey({
			key = "!",
			mods = "ALT",
		}),
	},
	{
		key = "l",
		mods = "SUPER|SHIFT",
		action = act.SendKey({
			key = "@",
			mods = "ALT",
		}),
	},
	{
		key = "j",
		mods = "SUPER|SHIFT",
		action = act.SendKey({
			key = "#",
			mods = "ALT",
		}),
	},
	{
		key = "k",
		mods = "SUPER|SHIFT",
		action = act.SendKey({
			key = "$",
			mods = "ALT",
		}),
	},
	{
		key = "d",
		mods = "SUPER",
		action = act.SendKey({
			key = "5",
			mods = "ALT",
		}),
	},
	-- exit session
	{
		key = "e",
		mods = "SUPER",
		action = act.SendKey({
			key = "%",
			mods = "ALT",
		}),
	},
	{
		key = "Tab",
		mods = "CTRL",
		action = act.SendKey({
			key = "6",
			mods = "ALT",
		}),
	},
	{
		key = "Tab",
		mods = "CTRL|SHIFT",
		action = act.SendKey({
			key = "^",
			mods = "ALT",
		}),
	},
	{
		key = "Tab",
		mods = "ALT",
		action = act.SendKey({
			key = "7",
			mods = "ALT",
		}),
	},
	{
		key = "Tab",
		mods = "ALT|SHIFT",
		action = act.SendKey({
			key = "&",
			mods = "ALT",
		}),
	},
	{
		key = "t",
		mods = "SUPER",
		action = act.SendKey({
			key = "8",
			mods = "ALT",
		}),
	},
	{
		key = "w",
		mods = "SUPER",
		action = act.SendKey({
			key = "9",
			mods = "ALT",
		}),
	},
	{
		key = "f",
		mods = "SUPER",
		action = act.SendKey({
			key = "0",
			mods = "ALT",
		}),
	},
	{
		key = "r",
		mods = "SUPER|SHIFT",
		action = act.SendKey({
			key = "_",
			mods = "ALT",
		}),
	},
	{
		key = "m",
		mods = "SUPER|SHIFT",
		action = act.SendKey({
			key = "*",
			mods = "ALT",
		}),
	},
	{
		key = "s",
		mods = "SUPER|SHIFT",
		action = act.SendKey({
			key = "-",
			mods = "ALT",
		}),
	},
	-- for neovim in zellij
	{
		key = ";",
		mods = "CTRL",
		action = act.SendKey({
			key = ";",
			mods = "ALT",
		}),
	},
	{
		key = "'",
		mods = "CTRL",
		action = act.SendKey({
			key = "'",
			mods = "ALT",
		}),
	},
	-- activate copy mode
	{ key = "v", mods = "LEADER", action = act.ActivateCopyMode },
	-- activate pane mode
	{ key = "p", mods = "LEADER", action = act.ActivateKeyTable({ name = "pane", one_shot = false }) },
	-- activate workspace mode
	{ key = "w", mods = "LEADER", action = act.ActivateKeyTable({ name = "workspace" }) },
}
