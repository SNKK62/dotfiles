local telescope = require("telescope")

telescope.setup({
	defaults = {
		mappings = {},
		file_ignore_patterns = {
			"node%_modules/.*",
			".git/.*",
			".cache/.*",
			".DS_Store",
		},
	},
	pickers = {
		find_files = {
			hidden = true,
		},
	},
})
