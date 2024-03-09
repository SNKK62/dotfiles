return function()
	require("nvim-highlight-colors").setup({
		render = "background", -- or 'foreground' or 'virtual'
		enable_named_colors = true,
		enable_tailwind = false, -- Highlight all files, but customize some others
	})
end
