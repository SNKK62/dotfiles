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

local function merge_tables(t1, t2)
	local merged = {}
	for _, v in ipairs(t1) do
		table.insert(merged, v)
	end
	for _, v in ipairs(t2) do
		table.insert(merged, v)
	end
	return merged
end

local common_plugins = {
	--others
	{
		"t9md/vim-quickhl",
	},
	{
		"mizlan/iswap.nvim",
		event = "VeryLazy",
		config = require("plugins/iswap"),
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
	{
		"ggandor/lightspeed.nvim",
	},
	{
		"hadronized/hop.nvim",
		branch = "v2",
		config = require("plugins/hop"),
	},
	{
		"bkad/CamelCaseMotion",
	},
	{
		"unblevable/quick-scope",
	},

	-- treesitter for iswap.nvim
	{
		"nvim-treesitter/nvim-treesitter",
		config = require("plugins/treesitter"),
		build = ":TSUpdate",
	},
	{
		"ThePrimeagen/refactoring.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("refactoring").setup()
		end,
	},
}

local pure_plugins = {
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
	-- {
	-- 	"folke/tokyonight.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	opts = {
	-- 		-- transparent = true,
	-- 		styles = {
	-- 			-- sidebars = "transparent",
	-- 			-- floats = "transparent",
	-- 		},
	-- 	},
	-- },
	-- {
	-- 	"neanias/everforest-nvim",
	-- 	version = false,
	-- 	lazy = false,
	-- 	priority = 1000, -- make sure to load this before all the other start plugins
	-- 	-- Optional; default configuration will be used if setup isn't called.
	-- 	config = function()
	-- 		require("everforest").setup({
	-- 			-- Your config here
	-- 		})
	-- 	end,
	-- },
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
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
	-- completion
	"hrsh7th/nvim-cmp",
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",
	"hrsh7th/vim-vsnip", -- snippet engine
	"hrsh7th/cmp-vsnip",
	"onsails/lspkind.nvim",

	-- actions
	{
		"aznhe21/actions-preview.nvim",
		config = function()
			require("actions-preview").setup({
				telescope = {
					sorting_strategy = "ascending",
					layout_strategy = "vertical",
					layout_config = {
						width = 0.8,
						height = 0.9,
						prompt_position = "top",
						preview_cutoff = 20,
						preview_height = function(_, _, max_lines)
							return max_lines - 15
						end,
					},
				},
			})
		end,
	},

	-- session
	{
		"rmagatti/auto-session",
		config = require("plugins/auto-session"),
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
		"mvllow/modes.nvim",
		rev = "v0.2.0",
		config = require("plugins/modes"),
	},
	{
		"sidebar-nvim/sidebar.nvim",
		config = require("plugins/sidebar"),
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
			require("scrollbar.handlers.gitsigns").setup()
		end,
	},
	{
		"brenoprata10/nvim-highlight-colors",
		event = { "BufEnter", "BufWinEnter" },
		config = require("plugins/highlight-colors"),
	},
	{
		"andymass/vim-matchup",
	},
	{
		"github/copilot.vim",
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		config = require("plugins/indent-blankline"),
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
		"petertriho/nvim-scrollbar",
		config = require("plugins/scrollbar"),
	},
	{
		"kevinhwang91/nvim-hlslens",
		config = function()
			require("scrollbar.handlers.search").setup()
		end,
	},
}

local vscode_plugins = {}

require("lazy").setup(merge_tables(common_plugins, vim.g.vscode and vscode_plugins or pure_plugins))

if not vim.g.vscode then
	require("plugins/gitgutter")
	require("plugins/lsp")
	require("plugins/lspsaga")
	require("plugins/cmp")
	require("plugins/null-ls")
	require("plugins/telescope")
end
