local keymap = vim.keymap.set

vim.g.mapleader = " "

-- cursor motion
keymap({ "n", "v" }, "<C-j>", "15j", { noremap = true })
keymap({ "n", "v" }, "<DOWN>", "15j", { noremap = true })
keymap({ "n", "v" }, "<C-k>", "15k", { noremap = true })
keymap({ "n", "v" }, "<UP>", "15k", { noremap = true })
keymap({ "n", "v" }, "<C-h>", "10h", { noremap = true })
keymap({ "n", "v" }, "<LEFT>", "10h", { noremap = true })
keymap({ "n", "v" }, "<C-l>", "10l", { noremap = true })
keymap({ "n", "v" }, "<RIGHT>", "10l", { noremap = true })

keymap({ "n", "v" }, ";;", "$", { noremap = true })
keymap({ "n", "v" }, "''", "^", { noremap = true })
keymap("i", "<C-;>", "<C-o>$", { noremap = true })
keymap("i", "<C-'>", "<C-o>^", { noremap = true })

keymap("i", "<C-j>", "<DOWN>", { noremap = true })
keymap("i", "<C-k>", "<UP>", { noremap = true })
keymap("i", "<C-h>", "<LEFT>", { noremap = true })
keymap("i", "<C-l>", "<RIGHT>", { noremap = true })

keymap("n", "F<CR>", "{", { noremap = true })
keymap("n", "f<CR>", "}", { noremap = true })

-- buffer
-- delete
keymap({ "n", "x" }, "x", '"_x', { noremap = true })
keymap("n", "D", '"_d', { noremap = true })

-- word object
keymap({ "o", "x" }, "i<SPACE>", "iW", { noremap = true })

-- redo
keymap("n", "U", "<C-r>", { noremap = true })

-- matchup
keymap("n", "M", "<plug>(matchup-%)", { noremap = true, silent = true })

-- release prefix-q
keymap("n", "q", "<NOP>", { noremap = true })
-- macro
-- only q is used for recording
keymap("n", "qq", "qq", { noremap = true })
keymap("n", "<ESC>", "q", { noremap = true, silent = true })
keymap("n", "Q", "v:lua.toggle_macro_playback()", { noremap = true, expr = true, silent = true })
function _G.toggle_macro_playback()
	if vim.fn.reg_recording() == "" then
		-- not in recording
		return "@q"
	else
		-- in recording
		return "q"
	end
end

-- selection
keymap("x", "y", "mzy`z", { noremap = true })
keymap("n", "gV", "`[V`]", { noremap = true })

-- paste
keymap("x", "p", "P", { noremap = true })
keymap("n", "p", "]p`]", { noremap = true })
keymap("n", "P", "]P`]", { noremap = true })

-- indent in a row
keymap("x", "<", "<gv", { noremap = true })
keymap("x", ">", ">gv", { noremap = true })

-- move line
keymap("n", "<CS-k>", "$<Cmd>move-1-{v:count1}<CR>=l", { noremap = true })
keymap("n", "<CS-j>", "^<Cmd>move+{v:count1}<CR>=l", { noremap = true })
keymap("x", "<CS-k>", ":move '<-2<CR>gv=gv", { noremap = true, silent = true })
keymap("x", "<CS-j>", ":move '>+1<CR>gv=gv", { noremap = true, silent = true })

-- change case in insert mode
keymap("i", "<C-g>u", "<ESC>gUiwgi", { noremap = true })
keymap("i", "<C-g>l", "<ESC>guiwgi", { noremap = true })
keymap("i", "<C-g>c", "<ESC>bgUlgi", { noremap = true })

-- search
keymap("n", "/", "/\\v", { noremap = true })
keymap("n", "?", "?\\v", { noremap = true })
keymap("n", "<ESC><ESC>", ":nohl<CR>", { noremap = true, silent = true })

-- substitution
keymap("n", "<Leader>repw", ":%s/\\V<C-r><C-w>//g<LEFT><LEFT>", { noremap = true })
keymap(
	"x",
	"<Leader>repw",
	[["zy:%s/\V<C-r><C-r>=escape(@z,'/\')<CR>//gce<Left><Left><Left><Left>]],
	{ noremap = true }
)

if vim.g.vscode then
	-- substitution
	keymap("n", "<Leader>repg", ":%s//g", { noremap = true })
	keymap("n", "<Leader>repc", ":%s//gc", { noremap = true })
end

if not vim.g.vscode then
	-- substitution
	keymap("n", "<Leader>repg", ":%s//g<LEFT><LEFT>", { noremap = true })
	keymap("n", "<Leader>repc", ":%s//gc<LEFT><LEFT><LEFT>", { noremap = true })
	-- terminal mode setting
	keymap("t", "<Esc>", "<C-\\><C-n>", { noremap = true })
	keymap("n", "<C-w>t", "<Cmd>terminal<CR>", { noremap = true, silent = true })
	keymap("n", "<C-w>x", "<Cmd>belowright new<CR><Cmd>terminal<CR>", { noremap = true, silent = true })
	vim.api.nvim_create_autocmd("TermOpen", {
		pattern = "*",
		callback = function()
			vim.cmd("startinsert")
			vim.opt_local.relativenumber = false
			vim.opt_local.number = false
		end,
	})

	-- filer (neo-tree)
	keymap("n", "<C-f>", function()
		require("neo-tree.command").execute({
			toggle = true,
			source = "filesystem",
			position = "right",
		})
	end)
	keymap("n", "<CS-G>", function()
		require("neo-tree.command").execute({
			toggle = true,
			source = "git_status",
			position = "right",
		})
	end)
	-- sideber
	keymap("n", "<CS-F>", function()
		require("sidebar-nvim").toggle()
	end)

	-- telescope
	local builtin = require("telescope.builtin")
	keymap("n", "<C-p>", builtin.find_files, {})
	keymap("n", "<C-g>", builtin.live_grep, {})
	keymap("n", "<CS-B>", builtin.buffers, {})

	-- treesitter-context
	keymap("n", "<Leader>tsc", "<Cmd>TSContextToggle<CR>", { noremap = true, silent = true })

	-- vim-spectre
	keymap("n", "<CS-R>", '<cmd>lua require("spectre").toggle()<CR>')

	-- git
	keymap("n", "<Leader><C-a>", ":Gwrite<CR>", { noremap = true })
	keymap("n", "<Leader>ga", ":!git add<Space>", { noremap = true })
	keymap("n", "<Leader>gc", ":!git commit -m ''<LEFT>", { noremap = true })
	keymap("n", "<Leader><C-p>", ":!git push<CR>", { noremap = true })
	keymap("n", "<Leader>gp", ":!git push -u origin<Space>", { noremap = true })
	keymap("n", "<Leader>gd", ":Gdiff<CR>", { noremap = true })
	keymap("n", "<Leader>gb", ":Git blame<CR>", { noremap = true })
	keymap("n", "<Leader>gs", ":Git status<CR>", { noremap = true })
	keymap("n", "<Leader>ghp", ":GitGutterPrevHunk<CR>", { noremap = true })
	keymap("n", "<Leader>ghn", ":GitGutterNextHunk<CR>", { noremap = true })
	keymap("n", "<Leader>ghl", ":GitGutterLineHighlightsToggle<CR>", { noremap = true })
	keymap("n", "<Leader>gpr", ":GitGutterPreviewHunk<CR>", { noremap = true })

	-- comment/uncomment
	keymap("n", "<C-/>", "<C-_><C-_>", { remap = true })
	keymap("i", "<C-/>", "<C-_><C-_>", { remap = true })
	keymap("v", "<C-/>", "gc", { remap = true })

	-- barbar
	-- switch buffer
	keymap("n", "<C-b>h", "<Cmd>BufferPrevious<CR>", { noremap = true, silent = true })
	keymap("n", "˙", "<Cmd>BufferPrevious<CR>", { noremap = true, silent = true }) -- <A-h>
	keymap("n", "<A-h>", "<Cmd>BufferPrevious<CR>", { noremap = true, silent = true })
	keymap("n", "<C-b>l", "<Cmd>BufferNext<CR>", { noremap = true, silent = true })
	keymap("n", "¬", "<Cmd>BufferNext<CR>", { noremap = true, silent = true }) -- <A-l>
	keymap("n", "<A-l>", "<Cmd>BufferNext<CR>", { noremap = true, silent = true })
	-- reorder buffer
	keymap("n", "<C-b>j", "<Cmd>BufferMovePrevious<CR>", { noremap = true, silent = true })
	keymap("n", "∆", "<Cmd>BufferMovePrevious<CR>", { noremap = true, silent = true }) -- <A-j>
	keymap("n", "<A-j>", "<Cmd>BufferMovePrevious<CR>", { noremap = true, silent = true })
	keymap("n", "<C-b>k", "<Cmd>BufferMoveNext<CR>", { noremap = true, silent = true })
	keymap("n", "˚", "<Cmd>BufferMoveNext<CR>", { noremap = true, silent = true }) -- <A-k>
	keymap("n", "<A-k>", "<Cmd>BufferMoveNext<CR>", { noremap = true, silent = true })
	-- pin/unpin buffer
	keymap("n", "<C-b>p", "<Cmd>BufferPin<CR>", { noremap = true, silent = true })
	-- close buffer
	keymap("n", "<C-b>c", "<Cmd>BufferClose<CR>", { noremap = true, silent = true })
	-- restore buffer
	keymap("n", "<C-b>z", "<Cmd>BufferRestore<CR>", { noremap = true, silent = true })
	-- magic buffer-picking mode
	keymap("n", "<C-b>s", "<Cmd>BufferPick<CR>", { noremap = true, silent = true })
	keymap("n", "<C-b>d", "<Cmd>BufferPickDelete<CR>", { noremap = true, silent = true })

	-- lsp
	-- finder
	keymap("n", "<Leader>fi", "<cmd>Lspsaga finder tyd+ref+imp+def<CR>", { silent = true })
	-- reference
	keymap("n", "<Leader>rf", "<cmd>Lspsaga finder ref<CR>", { silent = true })
	-- definition
	keymap("n", "<Leader>df", "<Cmd>tab lua vim.lsp.buf.definition()<CR>", { silent = true })
	-- type definition
	keymap("n", "<Leader>ty", "<cmd>Lspsaga finder tyd<CR>", { silent = true })
	-- implementation
	keymap("n", "<Leader>ip", "<cmd>Lspsaga finder imp<CR>", { silent = true })
	-- rename
	keymap("n", "<Leader>rn", "<cmd>Lspsaga rename<CR>", { silent = true })
	-- document
	keymap("n", "K", "<cmd>Lspsaga hover_doc ++quiet<CR>", { silent = true })
	-- diagnostics
	keymap("n", "<Leader>dl", "<cmd>Lspsaga show_line_diagnostics<CR>", { silent = true })
	keymap("n", "<Leader>dp", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { silent = true })
	keymap("n", "<Leader>dn", "<cmd>Lspsaga diagnostic_jump_next<CR>", { silent = true })
	keymap("n", "<Leader>db", "<cmd>Lspsaga show_buf_diagnostics<CR>", { silent = true })
	keymap("n", "<Leader>dw", function()
		require("telescope.builtin").diagnostics({
			severity_limit = 3, -- only show more than INFO
		})
	end, { silent = true })

	-- action
	keymap({ "n", "v" }, "<Leader>ac", require("actions-preview").code_actions, { silent = true })
	-- float terminal
	keymap({ "n", "t" }, "ƒ", "<cmd>Lspsaga term_toggle<CR>", { silent = true }) -- <A-f>
	keymap({ "n", "t" }, "<A-f>", "<cmd>Lspsaga term_toggle<CR>", { silent = true })

	-- session
	keymap("c", "SS", "SessionSave", { noremap = true })
	keymap("n", "<C-S>", "<cmd>Telescope session-lens search_session<CR>", { noremap = true, silent = true })

	-- copilot
	keymap("i", "<C-g>d", "<Plug>(copilot-dismiss)", { noremap = true })
	keymap("i", "<C-g>n", "<Plug>(copilot-next)", { noremap = true })
	keymap("i", "<C-g>p", "<Plug>(copilot-previous)", { noremap = true })
	keymap("i", "<C-g>w", "<Plug>(copilot-accept-word)", { noremap = true })
	-- keymap("i", "<C-g>l", "<Plug>(copilot-accept-line)", { noremap = true })
end

-- iswap
keymap("n", "<Leader>sw", "<Cmd>ISwap<CR>", { noremap = true, silent = true })
keymap("n", "<Leader>sn", "<Cmd>ISwapNode<CR>", { noremap = true, silent = true })

-- highlight mark setting
keymap({ "n", "x" }, "<Leader>m", "<Plug>(quickhl-manual-this)", { noremap = true })
keymap({ "n", "x" }, "<Leader>M", "<Plug>(quickhl-manual-reset)", { noremap = true })

-- disable lightspeed
-- keymap({ "n", "v" }, "s", "s", { noremap = true })
-- keymap({ "n", "v" }, "S", "S", { noremap = true })

-- hop
keymap({ "n", "v" }, "<Leader>h", "<Cmd>HopWord<CR>", { noremap = true, silent = true })

-- CamelCaseMotion
keymap({ "n", "v" }, "w", "<Plug>CamelCaseMotion_w", { noremap = true })
keymap({ "n", "v" }, "b", "<Plug>CamelCaseMotion_b", { noremap = true })
keymap({ "n", "v" }, "e", "<Plug>CamelCaseMotion_e", { noremap = true })
keymap({ "n", "v" }, "ge", "<Plug>CamelCaseMotion_ge", { noremap = true })
