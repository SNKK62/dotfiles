return function()
	local palette = require("palette")
	local colors = require("colors")
	require("bufferline").setup({
		options = {
			mode = "buffers",
			diagnostics = "nvim_lsp",
			numbers = "none",
			separator_style = "slant", -- "slant" | "slope" | "thick" | "thin"
			show_buffer_close_icons = true,
			show_close_icon = true,
			color_icons = true,
		},
		highlights = {
			fill = { -- The color of the remainder at the end
				fg = "#000000",
				bg = "#000000",
			},
			separator = {
				fg = "#000000", -- between buffers
				bg = colors.alpha_blend(palette.base, "#ffffff", 0.8),
			},
			background = {
				fg = palette.text,
				bg = colors.alpha_blend(palette.base, "#ffffff", 0.8),
			},
			close_button = {
				fg = palette.text,
				bg = colors.alpha_blend(palette.base, "#ffffff", 0.8),
			},
			diagnostic = {
				bg = colors.alpha_blend(palette.base, "#ffffff", 0.8),
			},
			error = {
				fg = palette.red,
				bg = colors.alpha_blend(palette.base, "#ffffff", 0.8),
			},
			warning = {
				fg = palette.peach,
				bg = colors.alpha_blend(palette.base, "#ffffff", 0.8),
			},
			info = {
				fg = palette.blue,
				bg = colors.alpha_blend(palette.base, "#ffffff", 0.8),
			},
			hint = {
				fg = palette.green,
				bg = colors.alpha_blend(palette.base, "#ffffff", 0.8),
			},
			modified = {
				bg = colors.alpha_blend(palette.base, "#ffffff", 0.8),
			},
			pick = {
				bg = colors.alpha_blend(palette.base, "#ffffff", 0.8),
			},
			separator_selected = {
				fg = "#000000", -- between buffers
				bg = colors.alpha_blend(palette.base, "#ffffff", 0.55),
			},
			buffer_selected = {
				fg = palette.text,
				bg = colors.alpha_blend(palette.base, "#ffffff", 0.55),
				bold = true,
			},
			close_button_selected = {
				fg = palette.text,
				bg = colors.alpha_blend(palette.base, "#ffffff", 0.55),
			},
			diagnostic_selected = {
				bg = colors.alpha_blend(palette.base, "#ffffff", 0.55),
			},
			error_selected = {
				bg = colors.alpha_blend(palette.base, "#ffffff", 0.55),
			},
			warning_selected = {
				fg = palette.peach,
				bg = colors.alpha_blend(palette.base, "#ffffff", 0.55),
			},
			info_selected = {
				fg = palette.blue,
				bg = colors.alpha_blend(palette.base, "#ffffff", 0.55),
			},
			hint_selected = {
				fg = palette.green,
				bg = colors.alpha_blend(palette.base, "#ffffff", 0.55),
			},
			modified_selected = {
				bg = colors.alpha_blend(palette.base, "#ffffff", 0.55),
			},
			pick_selected = {
				bg = colors.alpha_blend(palette.base, "#ffffff", 0.55),
			},
		},
	})
end
