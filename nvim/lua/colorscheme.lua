local M = {}

M.name = "catppuccin"

M.set = function()
	vim.cmd.colorscheme(M.name)
end

return M
