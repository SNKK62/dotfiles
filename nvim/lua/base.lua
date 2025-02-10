local opt = vim.opt

if not vim.g.vscode then
	opt.guifont = "HackGen35 Console NF:h13"
	opt.number = true
	opt.syntax = "on"
	opt.termguicolors = true
	opt.title = true
	opt.list = true
	opt.listchars = "tab:>_,trail:~,extends:>,precedes:<,nbsp:%,eol:↲"
	opt.autoindent = true
	opt.tabstop = 4
	opt.shiftwidth = 0 -- depend on tabstop
	opt.softtabstop = -1 -- depend on shiftwidth
	opt.expandtab = true
	opt.encoding = "utf-8"
	opt.wrap = true
	opt.laststatus = 3
	opt.cmdheight = 1
	opt.completeopt = "menuone"
	opt.backspace = "indent,eol,start"
	opt.cursorline = true
	opt.conceallevel = 0
	opt.backup = false
	opt.writebackup = false
	opt.swapfile = false

	vim.api.nvim_create_augroup("indent", { clear = true })
	vim.api.nvim_create_autocmd({ "FileType" }, {
		group = "indent",
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
		callback = function()
			opt.tabstop = 2
		end,
	})
	vim.api.nvim_create_augroup("indent6", { clear = true })
	vim.api.nvim_create_autocmd({ "FileType" }, {
		group = "indent6",
		pattern = {
			"ocaml",
		},
		callback = function()
			opt.tabstop = 6
		end,
	})
	vim.api.nvim_create_augroup("indentTab", { clear = true })
	vim.api.nvim_create_autocmd({ "FileType" }, {
		group = "indentTab",
		pattern = {
			"c",
		},
		callback = function()
			opt.tabstop = 4
			opt.expandtab = false
		end,
	})
end

opt.updatetime = 500
opt.inccommand = "split"
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

vim.o.clipboard = "unnamedplus"

local function paste()
	return {
		vim.fn.split(vim.fn.getreg(""), "\n"),
		vim.fn.getregtype(""),
	}
end

vim.g.clipboard = {
	name = "OSC 52",
	copy = {
		["+"] = require("vim.ui.clipboard.osc52").copy("+"),
		["*"] = require("vim.ui.clipboard.osc52").copy("*"),
	},
	paste = {
		["+"] = paste,
		["*"] = paste,
	},
}
