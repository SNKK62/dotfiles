return function()
	local palette = require("palette")
	local colors = require("colors")
	local utils = require("utils")
	utils.set_highlights("buffer_line_underline_indicator_highlight", {
		-- this is required for underline indicator
		TabLineSel = {
			bg = palette.red,
		},
	})

	local normal_bg = colors.alpha_blend(palette.background, "#ffffff", 0.85)
	local selected_bg = colors.alpha_blend(palette.background, "#ffffff", 0.55)
	local normal_fg = colors.alpha_blend(palette.text, palette.background, 0.6)
	require("bufferline").setup({
		options = {
			mode = "buffers",
			numbers = "none",
			separator_style = "slope", -- "slant" | "slope" | "thick" | "thin"
			show_buffer_close_icons = true,
			show_close_icon = true,
			color_icons = true,
			indicator = {
				-- this requires underline_thickness in terminal setting
				-- TabLineSel is the color of the underline
				style = "underline",
			},
			diagnostics = "nvim_lsp",
			---@diagnostic disable-next-line: unused-local
			diagnostics_indicator = function(count, level, diagnostics_dict, context)
				local output = ""
				for k, v in pairs(diagnostics_dict) do
					if k:match("error") then
						if output ~= "" then
							output = output .. " | "
						end
						output = output .. " " .. v
					elseif k:match("warning") then
						if output ~= "" then
							output = output .. " | "
						end
						output = output .. " " .. v
					end
				end
				return output
			end,
			custom_areas = {
				right = function()
					local result = {}
					local seve = vim.diagnostic.severity
					local error = #vim.diagnostic.get(0, { severity = seve.ERROR })
					local warning = #vim.diagnostic.get(0, { severity = seve.WARN })
					local info = #vim.diagnostic.get(0, { severity = seve.INFO })
					local hint = #vim.diagnostic.get(0, { severity = seve.HINT })

					if error ~= 0 then
						table.insert(result, { text = "  " .. error, link = "DiagnosticError" })
					end

					if warning ~= 0 then
						table.insert(result, { text = "  " .. warning, link = "DiagnosticWarn" })
					end

					if hint ~= 0 then
						table.insert(result, { text = "  " .. hint, link = "DiagnosticHint" })
					end

					if info ~= 0 then
						table.insert(result, { text = "  " .. info, link = "DiagnosticInfo" })
					end
					return result
				end,
			},
		},
		highlights = {
			fill = { -- The color of the remainder at the end
				fg = palette.background,
				bg = palette.background,
			},
			background = {
				fg = normal_fg,
				bg = normal_bg,
			},
			buffer_selected = {
				fg = palette.text,
				bg = selected_bg,
				bold = true,
			},
			separator = {
				fg = palette.background, -- between buffers
				bg = normal_bg,
			},
			separator_selected = {
				fg = palette.background, -- between buffers
				bg = selected_bg,
			},
			close_button = {
				fg = normal_fg,
				bg = normal_bg,
			},
			close_button_selected = {
				fg = palette.text,
				bg = selected_bg,
			},
			diagnostic = {
				bg = normal_bg,
			},
			diagnostic_selected = {
				bg = selected_bg,
			},
			error = {
				fg = palette.error,
				bg = normal_bg,
			},
			error_selected = {
				fg = palette.error,
				bg = selected_bg,
			},
			error_diagnostic = {
				fg = palette.error,
				bg = normal_bg,
			},
			error_diagnostic_selected = {
				fg = palette.error,
				bg = selected_bg,
			},
			warning = {
				fg = palette.warn,
				bg = normal_bg,
			},
			warning_selected = {
				fg = palette.warn,
				bg = selected_bg,
			},
			warning_diagnostic = {
				fg = palette.warn,
				bg = normal_bg,
			},
			warning_diagnostic_selected = {
				fg = palette.warn,
				bg = selected_bg,
			},
			info = {
				fg = palette.info,
				bg = normal_bg,
			},
			info_selected = {
				fg = palette.info,
				bg = selected_bg,
			},
			hint = {
				fg = palette.hint,
				bg = normal_bg,
			},
			hint_selected = {
				fg = palette.hint,
				bg = selected_bg,
			},
			modified = {
				bg = normal_bg,
			},
			modified_selected = {
				bg = selected_bg,
			},
			pick = {
				bg = normal_bg,
			},
			pick_selected = {
				bg = selected_bg,
			},
			duplicate = {
				fg = normal_fg,
				bg = normal_bg,
			},
			duplicate_selected = {
				fg = palette.text,
				bg = selected_bg,
			},
		},
	})
end
