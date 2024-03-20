local opt = vim.opt

if not vim.g.vscode then
	opt.guifont = "HackGen35 Console NF:h13"
	opt.number = true
	opt.syntax = "on"
	opt.termguicolors = true
	opt.background = "dark"
	opt.title = true
	opt.list = true
	opt.listchars = "tab:>_,trail:~,extends:>,precedes:<,nbsp:%,eol:↲"
	-- opt.ambiwidth = double
	opt.autoindent = true
	opt.shiftwidth = 4
	opt.softtabstop = 4
	opt.expandtab = true
	opt.encoding = "utf-8"
	opt.laststatus = 2
	opt.cmdheight = 2
	opt.completeopt = "menuone"
	opt.backspace = "indent,eol,start"
	opt.cursorline = true
	vim.cmd([[hi clear CursorLine]])
	opt.conceallevel = 0
	opt.backup = false
	opt.writebackup = false
	opt.swapfile = false

	-- color scheme
	vim.cmd([[colorscheme tokyonight]])

	-- fill columns after 80 with red
	opt.colorcolumn = "81"
	vim.cmd([[hi ColorColumn ctermbg=52 guibg=#42032c]])
	-- transparent background color
	vim.cmd([[hi NonText    ctermbg=None ctermfg=65 guibg=None guifg=#41946B]])
	vim.cmd([[hi SpecialKey ctermbg=None ctermfg=65 guibg=None guifg=#41946B]])

	vim.api.nvim_create_augroup("indent", { clear = true })
	vim.api.nvim_create_autocmd({ "FileType" }, {
		pattern = {
			"javascript",
			"typescript",
			"javascriptreact",
			"typescriptreact",
			"json",
			"html",
			"css",
			"yaml",
		},
		group = "indent",
		command = "setlocal shiftwidth=2",
	})
end

opt.updatetime = 500
opt.clipboard:append({ "unnamedplus" })
opt.inccommand = "split"
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
