-- define inlay hints colors
local colors = require("colors")
local palette = colors.palette
require("utils").force_set_highlights("lspconfig_hl", {
	-- https://github.com/catppuccin/vscode/blob/catppuccin-vsc-v3.15.2/packages/catppuccin-vsc/src/theme/extensions/error-lens.ts
	DiagnosticErrorLine = { bg = colors.alpha_blend(palette.red, palette.base, 0.15) },
	DiagnosticWarnLine = { bg = colors.alpha_blend(palette.peach, palette.base, 0.15) },
	DiagnosticInfoLine = { bg = colors.alpha_blend(palette.blue, palette.base, 0.15) },
	DiagnosticHintLine = { bg = colors.alpha_blend(palette.green, palette.base, 0.15) },
})
-- make background color of virtual text transparent
require("utils").set_highlights("lsp_dignostic_virtual_text", {
	DiagnosticVirtualTextError = { bg = "none" },
	DiagnosticVirtualTextWarn = { bg = "none" },
	DiagnosticVirtualTextInfo = { bg = "none" },
	DiagnosticVirtualTextHint = { bg = "none" },
})

-- diagnostics seviry
vim.diagnostic.config({
	severity_sort = true,
	virtual_text = {
		severity = { min = vim.diagnostic.severity.HINT },
		format = function(diagnostic)
			return string.format("%s (%s: %s)", diagnostic.message, diagnostic.source, diagnostic.code)
		end,
	},
	float = {
		severity = { min = vim.diagnostic.severity.HINT },
	},
	signs = {
		severity = { min = vim.diagnostic.severity.HINT },
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚",
			[vim.diagnostic.severity.WARN] = "󰀪",
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = "",
		},
		linehl = {
			[vim.diagnostic.severity.ERROR] = "DiagnosticErrorLine",
			[vim.diagnostic.severity.WARN] = "DiagnosticWarnLine",
			[vim.diagnostic.severity.INFO] = "DiagnosticInfoLine",
			[vim.diagnostic.severity.HINT] = "DiagnosticHintLine",
		},
	},
	underline = {
		severity = { min = vim.diagnostic.severity.WARN },
	},
})

local loaded_clients = {}

local function trigger_workspace_diagnostics(client, bufnr, workspace_files)
	if vim.tbl_contains(loaded_clients, client.id) then
		return
	end
	table.insert(loaded_clients, client.id)

	if not vim.tbl_get(client.server_capabilities, "textDocumentSync", "openClose") then
		return
	end

	for _, path in ipairs(workspace_files) do
		if path == vim.api.nvim_buf_get_name(bufnr) then
			goto continue
		end

		local filetype = vim.filetype.match({ filename = path })

		if not vim.tbl_contains(client.config.filetypes, filetype) then
			goto continue
		end

		local params = {
			textDocument = {
				uri = vim.uri_from_fname(path),
				version = 0,
				text = vim.fn.join(vim.fn.readfile(path), "\n"),
				languageId = filetype,
			},
		}
		client.notify("textDocument/didOpen", params)

		::continue::
	end
end

local function map(tbl, func)
	local t = {}
	for i, v in ipairs(tbl) do
		t[i] = func(i, v)
	end
	return t
end

-- Step 1: Get files under Git management with git ls-files
local workspace_files = vim.fn.split(vim.fn.system("git ls-files"), "\n")

-- Step 2: Get local changes with git status --porcelain
local status_output = vim.fn.system("git status --porcelain")
local status_lines = vim.fn.split(status_output, "\n")

for _, line in ipairs(status_lines) do
	-- if line starts with "??", it means untracked file
	if string.sub(line, 1, 2) == "??" then
		local new_file = string.sub(line, 4)
		table.insert(workspace_files, new_file)
	end
	-- if line starts with " D", it means deleted file
	if string.sub(line, 1, 2) == " D" then
		local deleted_file = vim.fn.matchstr(line, "^ D \\zs.*")
		for i, file in ipairs(workspace_files) do
			if file == deleted_file then
				table.remove(workspace_files, i)
				break
			end
		end
	end
end

-- Step 3: convert paths to absolute
workspace_files = vim.tbl_map(function(path)
	return vim.fn.fnamemodify(path, ":p")
end, workspace_files)

local general_on_attach = function(client, bufnr)
	--client.server_capabilities.documentFormattingProvider = false
	trigger_workspace_diagnostics(client, bufnr, workspace_files)
end
local capabilities = require("cmp_nvim_lsp").default_capabilities()

require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls",
		-- "luacheck", -- install directly
		-- "stylua", -- install directly
		"ts_ls",
		"eslint",
		--  "eslint_d", -- install directly
		--  "prettier",
		"jsonls",
		"tailwindcss",
		"prismals",
	},
})

local lspconfig = require("lspconfig")
require("mason-lspconfig").setup_handlers({
	function(server_name) -- default handler (optional)
		lspconfig[server_name].setup({
			on_attach = general_on_attach,
			capabilities = capabilities,
			handlers = {
				["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
					update_in_insert = true,
				}),
			},
		})
	end,
})

-- TypeScript
lspconfig.ts_ls.setup({
	on_attach = function(client, bufnr)
		general_on_attach(client, bufnr)
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
	filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
	handlers = {
		["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
			update_in_insert = true,
		}),
	},
})
-- eslint
lspconfig.eslint.setup({
	on_attach = function(client, bufnr)
		general_on_attach(client, bufnr)
		client.server_capabilities.documentFormattingProvider = true
		client.server_capabilities.documentRangeFormattingProvider = true
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = bufnr,
			command = "EslintFixAll",
		})
	end,
	handlers = {
		["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
			update_in_insert = true,
		}),
	},
})

-- Lua
lspconfig.lua_ls.setup({
	on_attach = function(client, bufnr)
		general_on_attach(client, bufnr)
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
	handlers = {
		["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
			update_in_insert = true,
		}),
	},
})
