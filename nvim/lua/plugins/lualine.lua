return function()
	require("lualine").setup({
		options = { theme = "catppuccin-mocha" },
		sections = {
			lualine_c = { "current session: " .. require("auto-session.lib").current_session_name },
		},
	})
end
