local null_ls = require("null-ls")
local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })

null_ls.setup({
	diagnostics_format = "#{m} (#{s}: #{c})",
	sources = {
		null_ls.builtins.formatting.stylua,
		-- null_ls.builtins.diagnostics.luacheck,
		null_ls.builtins.completion.spell,
		-- null_ls.builtins.diagnostics.eslint,
		-- null_ls.builtins.diagnostics.eslint_d.with({
		-- 	diagnostics_format = "[eslint] #{m}\n(#{c})",
		-- }),
		-- null_ls.builtins.formatting.prettier, -- TODO: Add more filetypes except js, jsx and t*
		-- null_ls.builtins.diagnostics.fish,
		null_ls.builtins.diagnostics.mypy.with({
			extra_args = { "--disable-error-code", "import-untyped", "--disable-error-code", "import" },
		}),
		null_ls.builtins.formatting.black,
	},
	on_attach = function(client, bufnr)
		vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({
						async = false,
					})
				end,
			})
		end
	end,
})
