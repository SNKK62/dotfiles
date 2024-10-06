local M = {}

M.name = "catppuccin"
M.theme = "mocha"

M.set = function()
	vim.cmd.colorscheme(M.name)
end

return M
