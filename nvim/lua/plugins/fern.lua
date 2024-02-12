vim.g["fern#default_hidden"] = 1
vim.g["fern#renderer"] = "nerdfont"
local id = vim.api.nvim_create_augroup("my-glyph-palette", {})
vim.api.nvim_create_autocmd({ "FileType" }, {
    group = id,
    pattern = { "fern", "nerdtree", "startify" },
    callback = "glyph_palette#apply",
})
vim.api.nvim_create_autocmd({ "FileType" }, {
    group = id,
    pattern = { "fern", "nerdtree", "startify" },
    callback = function() vim.opt_local.number = false end,
})
