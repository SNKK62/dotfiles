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
        rev = '0.1.2',
        dependencies = {
            "nvim-lua/plenary.nvim"
        }
    },
    -- git
    "airblade/vim-gitgutter",
    "tpope/vim-fugitive",

    -- colorscheme
    {
        "xiyaowong/transparent.nvim",
        rev = '4c3c392f285378e606d154bee393b6b3dd18059c'
    },
    "tomasiser/vim-code-dark",

    -- lsp
    {
        "nvimtools/none-ls.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        }
    },
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    {
        "nvimdev/lspsaga.nvim",
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'nvim-tree/nvim-web-devicons',
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

    "simeji/winresizer", -- <C-e>
    "romgrk/barbar.nvim",
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        }
    },
    "tomtom/tcomment_vim",
    "lukas-reineke/indent-blankline.nvim",
    "t9md/vim-quickhl",
    { 
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
    }
})

