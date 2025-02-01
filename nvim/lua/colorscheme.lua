local M = {}

-- M.name = "catppuccin"
M.name = "everforest"

M.set = function()
	vim.cmd.colorscheme(M.name)
end

return M
