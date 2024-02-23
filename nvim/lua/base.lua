local opt = vim.opt

opt.guifont = 'HackGen35 Console NF:h13'
opt.number = true
opt.syntax = 'on'
opt.termguicolors = true
opt.background = 'dark'
opt.title = true
opt.list = true
opt.listchars = 'tab:>_,trail:~,extends:>,precedes:<,nbsp:%,eol:↲'
opt.autoindent = true
-- opt.ambiwidth = double
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.encoding = 'utf-8'
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.laststatus = 2
opt.cmdheight = 2
opt.hlsearch = true
opt.completeopt = 'menuone'
opt.backspace = 'indent,eol,start'
opt.cursorline = true
vim.cmd[[hi clear CursorLine]]
opt.conceallevel = 0
opt.inccommand = 'split'
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.clipboard:append{'unnamedplus'}
opt.updatetime = 500

-- color scheme
vim.cmd[[colorscheme tokyonight]]
-- fill columns after 80 with red
opt.colorcolumn = '81'
vim.cmd[[hi ColorColumn ctermbg=52 guibg=#42032c]]
-- transparent background color
vim.cmd[[hi NonText    ctermbg=None ctermfg=65 guibg=None guifg=#41946B]]
vim.cmd[[hi SpecialKey ctermbg=None ctermfg=65 guibg=None guifg=#41946B]]
