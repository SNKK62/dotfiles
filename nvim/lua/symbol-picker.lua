local M = {}

local PRESETS = {
	{ name = "All", symbols = nil },
	{ name = "Fn/Method", symbols = { "Function", "Method" } },
	{ name = "Types", symbols = { "Class", "Interface", "Struct", "Enum" } },
	{ name = "Vars/Fields", symbols = { "Variable", "Field", "Constant", "Property" } },
	{ name = "Namespaces", symbols = { "Module", "Namespace", "Package" } },
	{ name = "Ctor", symbols = { "Constructor" } },
}

local function numbered_title(current_idx, is_workspace)
	local list = {}
	for i, p in ipairs(PRESETS) do
		if i == current_idx then
			table.insert(list, ("[%d]*%s*"):format(i, p.name))
		else
			table.insert(list, ("[%d]%s"):format(i, p.name))
		end
	end
	local head = is_workspace and "Workspace Symbols" or "Document Symbols"
	return ("%s  |  %s"):format(head, table.concat(list, "  "))
end

local function map_number_for_switch(fn, map)
	for i = 1, #PRESETS do
		map("n", tostring(i), function()
			fn(i)
		end)
	end
	return map
end

local function clamp(i)
	if i < 1 then
		return #PRESETS
	end
	if i > #PRESETS then
		return 1
	end
	return i
end

local function open_symbols_picker(state)
	local builtin = require("telescope.builtin")
	local actions = require("telescope.actions")

	local idx = state.idx or 1

	local function reopen(next_idx)
		idx = clamp(next_idx or idx)
		local current = PRESETS[idx]
		local picker = builtin.lsp_document_symbols
		picker({
			symbols = current.symbols,
			layout_strategy = "vertical",
			layout_config = {
				width = 0.95,
				height = 0.95,
				preview_cutoff = 0.6,
				prompt_position = "bottom",
			},
			sorting_strategy = "ascending",
			previewer = true,
			query = nil,
			prompt_title = numbered_title(idx),
			attach_mappings = function(prompt_bufnr, map)
				local function reopen_and_close(new_idx)
					actions.close(prompt_bufnr)
					vim.schedule(function()
						reopen(new_idx)
					end)
				end

				map("i", "<Tab>", function()
					reopen_and_close(idx + 1)
				end)
				map("i", "<S-Tab>", function()
					reopen_and_close(idx - 1)
				end)
				map("n", "<Tab>", function()
					reopen_and_close(idx + 1)
				end)
				map("n", "<S-Tab>", function()
					reopen_and_close(idx - 1)
				end)
				map_number_for_switch(reopen_and_close, map)

				return true
			end,
		})
	end

	reopen(idx)
end

function M.symbols_picker()
	open_symbols_picker({ idx = 1 })
end

return M
