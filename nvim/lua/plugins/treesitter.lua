return function()
	require("nvim-treesitter.configs").setup({
		ensure_installed = "all",
		highlight = {
			enable = true,
		},
		textsubjects = {
			enable = true,
			prev_selection = ".", -- (Optional) keymap to select the previous selection
			keymaps = {
				[";."] = "textsubjects-smart",
				[";o"] = "textsubjects-container-outer",
				[";i"] = "textsubjects-container-inner",
			},
		},
	})
end
