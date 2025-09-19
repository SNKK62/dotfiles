return function()
	require("nvim-treesitter.configs").setup({
		ensure_installed = "all",
		ignore_install = { "systemverilog", "ipkg" },
		highlight = {
			enable = true,
		},
	})
end
