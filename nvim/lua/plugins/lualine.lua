---@param theme string
---@return function
return function(theme)
	return function()
		require("lualine").setup({
			options = { theme = theme },
			sections = {
				lualine_c = {
					function()
						return "current session: " .. require("auto-session.lib").current_session_name(true)
					end,
				},
			},
		})
	end
end
