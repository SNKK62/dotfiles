-- install lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- file browser
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		config = require("plugins/neotree"),
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		},
	},

	-- browser
	{
		"nvim-telescope/telescope.nvim",
		rev = "0.1.2",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},
	{
		"nvim-pack/nvim-spectre",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = require("plugins/spectre"),
	},
	-- git
	{
		"airblade/vim-gitgutter",
	},
	{
		"tpope/vim-fugitive",
	},

	-- colorscheme
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			-- transparent = true,
			styles = {
				-- sidebars = "transparent",
				-- floats = "transparent",
			},
		},
	},

	-- lsp
	{
		"nvimtools/none-ls.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},
	{
		"MunifTanjim/prettier.nvim",
		config = require("plugins/prettier"),
	},
	{
		"williamboman/mason.nvim",
	},
	{
		"williamboman/mason-lspconfig.nvim",
	},
	{
		"neovim/nvim-lspconfig",
	},
	{
		"nvimdev/lspsaga.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
	},
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	-- completion
	"hrsh7th/nvim-cmp",
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",
	"hrsh7th/vim-vsnip", -- snippet engine
	"hrsh7th/cmp-vsnip",
	"onsails/lspkind.nvim",

	-- session
	{
		"rmagatti/auto-session",
		config = require("plugins/auto-session"),
	},
	{
		"rmagatti/session-lens",
		dependencies = { "rmagatti/auto-session", "nvim-telescope/telescope.nvim" },
		config = function()
			require("session-lens").setup()
		end,
	},

	-- others
	{
		"simeji/winresizer", -- <C-e>
	},
	{
		"romgrk/barbar.nvim",
		dependencies = {
			"lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
			"nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
		},
		init = function()
			vim.g.barbar_auto_setup = false
		end,
		config = require("plugins/barbar"),
	},
	{
		"nvim-lualine/lualine.nvim",
		config = require("plugins/lualine"),
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
	},
	{
		"tomtom/tcomment_vim",
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		config = require("plugins/indent-blankline"),
	},
	{
		"t9md/vim-quickhl",
	},
	{
		"nvim-treesitter/nvim-treesitter",
		config = require("plugins/treesitter"),
		build = ":TSUpdate",
	},
	{
		"yioneko/nvim-yati",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		config = require("plugins/yati"),
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		config = require("plugins/treesitter-context"),
	},
	{
		"mizlan/iswap.nvim",
		event = "VeryLazy",
		config = require("plugins/iswap"),
	},
	{
		"github/copilot.vim",
	},
	{
		"mvllow/modes.nvim",
		rev = "v0.2.0",
		config = require("plugins/modes"),
	},
	{
		"sidebar-nvim/sidebar.nvim",
		config = require("plugins/sidebar"),
	},
	{
		"petertriho/nvim-scrollbar",
		config = require("plugins/scrollbar"),
	},
	{
		"kevinhwang91/nvim-hlslens",
		config = function()
			require("scrollbar.handlers.search").setup()
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
			require("scrollbar.handlers.gitsigns").setup()
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		config = require("plugins/autotag"),
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},
	{
		"brenoprata10/nvim-highlight-colors",
		event = { "BufEnter", "BufWinEnter" },
		config = require("plugins/highlight-colors"),
	},
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	},
})

require("plugins/gitgutter")
require("plugins/lsp")
require("plugins/lspsaga")
require("plugins/cmp")
require("plugins/null-ls")
require("plugins/telescope")
