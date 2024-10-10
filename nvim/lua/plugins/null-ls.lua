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
	},
	on_attach = function(client, bufnr)
		vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
		if client.supports_method("textDocument/formatting") then
			if
				vim.tbl_contains(client.config.filetypes, "lua")
				-- TODO: Add more filetypes except js, jsx and t*
				-- or vim.tbl_contains(client.config.filetypes, "json")
				-- or vim.tbl_contains(client.config.filetypes, "yaml")
			then
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
		end
	end,
})
