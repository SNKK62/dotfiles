-- https://github.com/neanias/everforest-nvim/blob/616864c0c534b1eaf650ef913512dcde80ababfb/lua/everforest/colours.lua
local base_color = {
	fg = "#d3c6aa",
	red = "#e67e80",
	orange = "#e69875",
	yellow = "#dbbc7f",
	green = "#a7c080",
	aqua = "#83c092",
	blue = "#7fbbb3",
	purple = "#d699b6",
	grey0 = "#7a8478",
	grey1 = "#859289",
	grey2 = "#9da9a0",
	statusline1 = "#a7c080",
	statusline2 = "#d3c6aa",
	statusline3 = "#e67e80",
	none = "NONE",
}
local hard_background = {
	bg_dim = "#1e2326",
	bg0 = "#272e33",
	bg1 = "#2e383c",
	bg2 = "#374145",
	bg3 = "#414b50",
	bg4 = "#495156",
	bg5 = "#4f5b58",
	bg_visual = "#4c3743",
	bg_red = "#493b40",
	bg_green = "#3c4841",
	bg_blue = "#384b55",
	bg_yellow = "#45443c",
}
local soft_background = {
	bg_dim = "#293136",
	bg0 = "#333c43",
	bg1 = "#3a464c",
	bg2 = "#434f55",
	bg3 = "#4d5960",
	bg4 = "#555f66",
	bg5 = "#5d6b66",
	bg_visual = "#5c3f4f",
	bg_red = "#59464c",
	bg_green = "#48584e",
	bg_blue = "#3f5865",
	bg_yellow = "#55544a",
}
-- local palette = vim.tbl_extend("force", base_color, hard_background)
local palette = vim.tbl_extend("force", base_color, soft_background)
palette.text = palette.fg
palette.background = palette.bg0
palette.error = palette.red
palette.warn = palette.orange
palette.info = palette.blue
palette.hint = palette.aqua

-- indnet rainbow colors
palette.red = palette.red
palette.orange = palette.orange
palette.yellow = palette.yellow
palette.green = palette.green
palette.sky = palette.aqua
palette.blue = palette.blue
palette.purple = palette.purple

return palette
