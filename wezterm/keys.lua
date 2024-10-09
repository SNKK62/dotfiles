local wezterm = require("wezterm")
local act = wezterm.action
return {
	{
		-- workspaceの切り替え
		key = "w",
		mods = "LEADER",
		action = act.ShowLauncherArgs({ flags = "WORKSPACES", title = "Select workspace" }),
	},
	{
		--workspaceの名前変更
		key = "$",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = "(wezterm) Set workspace title:",
			action = wezterm.action_callback(function(win, pane, line)
				if line then
					wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
				end
			end),
		}),
	},
	{
		key = "W",
		mods = "LEADER|SHIFT",
		action = act.PromptInputLine({
			description = "(wezterm) Create new workspace:",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:perform_aciton(
						act.SwitchToWorkspace({
							name = line,
						}),
						pane
					)
				end
			end),
		}),
	},
	-- -- move back one word
	{
		key = "h",
		mods = "CTRL|SHIFT",
		action = wezterm.action_callback(function(window, pane)
			window:perform_action(act.SendKey({ key = "[", mods = "CTRL" }), pane)
			window:perform_action(act.SendKey({ key = "b" }), pane)
		end),
	},
	-- -- move forward one word
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
	{ key = "p", mods = "LEADER", action = act.ActivateKeyTable({ name = "pane", one_shot = false }) },
}
