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
        "lambdalisue/fern.vim",
        dependencies = {
            "lambdalisue/nerdfont.vim",
            "lambdalisue/fern-renderer-nerdfont.vim",
            "lambdalisue/glyph-palette.vim",
            "lambdalisue/fern-git-status.vim",
            "nvim-tree/nvim-web-devicons",
        }
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

    "simeji/winresizer", -- <C-e>
    "romgrk/barbar.nvim",
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        }
    },
    "tomtom/tcomment_vim",
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
    },
    "t9md/vim-quickhl"
})

