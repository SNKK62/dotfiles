local wezterm = require("wezterm")
local act = wezterm.action
return {
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
			key = "h",
			mods = "CTRL",
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
			key = "l",
			mods = "CTRL",
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
		{ key = "k", mods = "CTRL", action = act.CopyMode("MoveUp") },
		{ key = "DownArrow", mods = "NONE", action = act.CopyMode("MoveDown") },
		{ key = "j", mods = "CTRL", action = act.CopyMode("MoveDown") },
	},
	pane = {
		{ key = "h", action = act.ActivatePaneDirection("Left") },
		{ key = "l", action = act.ActivatePaneDirection("Right") },
		{ key = "k", action = act.ActivatePaneDirection("Up") },
		{ key = "j", action = act.ActivatePaneDirection("Down") },
		{
			key = "H",
			mods = "SHIFT",
			action = act.SplitPane({ direction = "Left" }),
		},
		{
			key = "L",
			mods = "SHIFT",
			action = act.SplitPane({ direction = "Right" }),
		},
		{
			key = "K",
			mods = "SHIFT",
			action = act.SplitPane({ direction = "Up" }),
		},
		{
			key = "J",
			mods = "SHIFT",
			action = act.SplitPane({ direction = "Down" }),
		},
		{ key = "h", mods = "CTRL", action = act.AdjustPaneSize({ "Left", 5 }) },
		{ key = "LeftArrow", action = act.AdjustPaneSize({ "Left", 5 }) },
		{ key = "l", mods = "CTRL", action = act.AdjustPaneSize({ "Right", 5 }) },
		{ key = "RightArrow", action = act.AdjustPaneSize({ "Right", 5 }) },
		{ key = "k", mods = "CTRL", action = act.AdjustPaneSize({ "Up", 5 }) },
		{ key = "UpArrow", action = act.AdjustPaneSize({ "Up", 5 }) },
		{ key = "j", mods = "CTRL", action = act.AdjustPaneSize({ "Down", 5 }) },
		{ key = "DownArrow", action = act.AdjustPaneSize({ "Down", 5 }) },
		{ key = "d", action = act({ CloseCurrentPane = { confirm = true } }) },
		-- Cancel the mode
		{ key = "Enter", action = "PopKeyTable" },
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "c", mods = "CTRL", action = "PopKeyTable" },
	},
	workspace = {
		{
			key = "s",
			action = act.ShowLauncherArgs({ flags = "WORKSPACES", title = "Select workspace" }),
		},
		{
			key = "r",
			action = act.PromptInputLine({
				description = "(wezterm) Set workspace title:",
				---@diagnostic disable-next-line: unused-local
				action = wezterm.action_callback(function(win, pane, line)
					if line then
						wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
					end
				end),
			}),
		},
		{
			key = "n",
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
		-- Cancel the mode
		{ key = "Enter", action = "PopKeyTable" },
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "c", mods = "CTRL", action = "PopKeyTable" },
	},
}
