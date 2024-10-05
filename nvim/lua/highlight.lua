local colors = require("colors")

-- color scheme
vim.cmd.colorscheme(colors.colorscheme)

-- fill columns after 80 with red
vim.opt.colorcolumn = "81"
vim.cmd([[hi ColorColumn ctermbg=52 guibg=#42032c]])

-- transparent background color
vim.cmd([[hi NonText    ctermbg=None ctermfg=65 guibg=None guifg=#41946B]]) -- eol, extends, precedes
vim.cmd([[hi SpecialKey ctermbg=None ctermfg=65 guibg=None guifg=#41946B]]) -- nbsp, tab, trail
vim.cmd([[hi Normal guibg=NONE ctermbg=NONE]]) -- disable background color
vim.cmd([[hi NormalNC guibg=NONE ctermbg=NONE]]) -- disable background color
