return function()
	local colors = require("colors")
	local palette = require("palette")
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
			colors.alpha_blend(palette.red, palette.background, alpha),
			colors.alpha_blend(palette.orange, palette.background, alpha),
			colors.alpha_blend(palette.yellow, palette.background, alpha),
			colors.alpha_blend(palette.green, palette.background, alpha),
			colors.alpha_blend(palette.sky, palette.background, alpha),
			colors.alpha_blend(palette.blue, palette.background, alpha),
			colors.alpha_blend(palette.purple, palette.background, alpha),
		},
	}):enable()
end
