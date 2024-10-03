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
		severity_sort = true,
		severity = { min = vim.diagnostic.severity.WARN },
	},
	signs = {
		severity = { min = vim.diagnostic.severity.HINT },
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

local workspace_files = vim.fn.split(vim.fn.system("git ls-files"), "\n")
-- convert paths to absolute
workspace_files = map(workspace_files, function(_, path)
	return vim.fn.fnamemodify(path, ":p")
end)

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
		-- "tsserver",
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
