return function()
	local colors = require("colors")
	local palette = colors.palette
	require("hlchunk").setup({
		chunk = {
			enable = true,
			use_treesitter = true,
			style = {
				{ fg = palette.green },
				{ fg = palette.red },
			},
			-- animation related
			duration = 0,
			delay = 0,
		},
	})
	local indent = require("hlchunk.mods.indent")
	local alpha = 0.45
	indent({
		style = {
			colors.alpha_blend(palette.red, palette.base, alpha),
			colors.alpha_blend(palette.peach, palette.base, alpha),
			colors.alpha_blend(palette.yellow, palette.base, alpha),
			colors.alpha_blend(palette.green, palette.base, alpha),
			colors.alpha_blend(palette.sky, palette.base, alpha),
			colors.alpha_blend(palette.blue, palette.base, alpha),
			colors.alpha_blend(palette.mauve, palette.base, alpha),
		},
	}):enable()
end
