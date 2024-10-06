return function()
	local colorscheme = require("colorscheme")
	require("lualine").setup({
		options = { theme = colorscheme.name },
		sections = {
			lualine_c = {
				function()
					return "current session: " .. require("auto-session.lib").current_session_name(true)
				end,
			},
		},
	})
end
