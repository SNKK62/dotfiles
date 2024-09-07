return function()
	require("lualine").setup({
		options = { theme = "everforest" },
		sections = { lualine_c = { require("auto-session.lib").current_session_name } },
	})
end
