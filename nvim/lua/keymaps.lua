local keymap = vim.keymap.set

vim.g.mapleader = " "

-- cursor motion

keymap({ "n", "v" }, "j", "gj", { noremap = true })
keymap({ "n", "v" }, "k", "gk", { noremap = true })

keymap({ "n", "v" }, "<C-j>", "12j", { noremap = true })
keymap({ "n", "v" }, "<DOWN>", "12j", { noremap = true })
keymap({ "n", "v" }, "<C-k>", "12k", { noremap = true })
keymap({ "n", "v" }, "<UP>", "12k", { noremap = true })
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

-- set the cursr position to the center
keymap("n", "<C-d>", "<C-d>zz", { noremap = true })
keymap("n", "<C-u>", "<C-u>zz", { noremap = true })
keymap("n", "n", "nzz", { noremap = true })
keymap("n", "N", "Nzz", { noremap = true })

-- buffer
-- delete
keymap({ "n", "x" }, "x", '"_x', { noremap = true })
keymap("n", "D", '"_d', { noremap = true })

-- word object
keymap({ "o", "x" }, "i<SPACE>", "iW", { noremap = true })

-- matchup
keymap({ "n", "x" }, "M", "<plug>(matchup-%)", { noremap = true, silent = true })

-- release prefix-q
keymap("n", "q", "<NOP>", { noremap = true })

-- macro
---@param key string key
function _G.set_macro_keybind(key)
	if vim.fn.reg_recording() == "" then
		-- not in recording
		return "q" .. key
	else
		-- in recording
		return "q"
	end
end
local macro_prefix = "Q"
local function add_macro(key)
	keymap(
		"n",
		macro_prefix .. key,
		"v:lua.set_macro_keybind('" .. key .. "')",
		{ noremap = true, expr = true, silent = true }
	)
end
-- only W is used for recording
add_macro("W")

keymap("n", "<ESC>", "v:lua.escape_in_macro()", { noremap = true, expr = true, silent = true })
function _G.escape_in_macro()
	if vim.fn.reg_recording() == "" then
		-- not in recording
		return "<ESC>"
	else
		-- in recording
		return "q"
	end
end

keymap("n", "@", "@W", { noremap = true })

-- selection
keymap("x", "y", "mzy`z", { noremap = true }) -- remain the cursor position
keymap("n", "gV", "`[V`]", { noremap = true }) -- select the last pasted text

-- paste
keymap("x", "p", "P", { noremap = true }) -- prevent polluting the register on paste in visual mode
keymap("n", "p", "]p`]", { noremap = true }) -- set the cursor position to the end of the pasted text
keymap("n", "P", "]P`]", { noremap = true }) -- set the cursor position to the end of the pasted text

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
keymap("i", "<C-g>h", "<ESC>bgUlgi", { noremap = true })

-- dial
vim.keymap.set("n", "<C-a>", function()
	require("dial.map").manipulate("increment", "normal")
end)
vim.keymap.set("n", "<C-x>", function()
	require("dial.map").manipulate("decrement", "normal")
end)
vim.keymap.set("n", "g<C-a>", function()
	require("dial.map").manipulate("increment", "gnormal")
end)
vim.keymap.set("n", "g<C-x>", function()
	require("dial.map").manipulate("decrement", "gnormal")
end)
vim.keymap.set("v", "<C-a>", function()
	require("dial.map").manipulate("increment", "visual")
end)
vim.keymap.set("v", "<C-x>", function()
	require("dial.map").manipulate("decrement", "visual")
end)
vim.keymap.set("v", "g<C-a>", function()
	require("dial.map").manipulate("increment", "gvisual")
end)
vim.keymap.set("v", "g<C-x>", function()
	require("dial.map").manipulate("decrement", "gvisual")
end)

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
keymap("n", "<Leader>repg", ":%s//g<LEFT><LEFT>", { noremap = true })
keymap("n", "<Leader>repc", ":%s//gc<LEFT><LEFT><LEFT>", { noremap = true })

if vim.g.vscode then
	-- substitution
	keymap("n", "<Leader>repg", ":%s//g", { noremap = true })
	keymap("n", "<Leader>repc", ":%s//gc", { noremap = true })
end

if not vim.g.vscode then
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

	-- telescope
	local builtin = require("telescope.builtin")
	keymap("n", "<C-p>", builtin.find_files, {})
	keymap("n", "<C-g>", builtin.live_grep, {})
	keymap("n", "<CS-B>", builtin.buffers, {})

	-- treesitter-context
	keymap("n", "<Leader>tsc", "<Cmd>TSContextToggle<CR>", { noremap = true, silent = true })
	-- treesitter-context-vt
	keymap("n", "<Leader>tsv", "<Cmd>TSContextVToggle<CR>", { noremap = true, silent = true })

	-- splitting/joining
	vim.keymap.set("n", "<Leader>sj", require("treesj").toggle)
	vim.keymap.set("n", "<Leader>sJ", function()
		require("treesj").toggle({ split = { recursive = true } })
	end)

	-- git
	-- diff
	keymap("n", "<Leader>gd", "<Cmd>DiffviewOpen<CR>", { noremap = true, silent = true })
	-- history
	keymap("n", "<Leader>gh", "<Cmd>DiffviewFileHistory<CR>", { noremap = true, silent = true })
	-- close
	keymap("n", "<Leader>gc", "<Cmd>DiffviewClose<CR>", { noremap = true, silent = true })
	-- blame
	keymap("n", "<Leader>gb", require("gitsigns").blame)
	-- preview
	keymap("n", "<Leader>gp", require("gitsigns").preview_hunk)
	-- messenger
	keymap("n", "<Leader>gm", "<Cmd>GitMessenger<CR>", { noremap = true, silent = true })
	-- add
	keymap("n", "<Leader>ga", "<A-f>fga<CR>", { remap = true })
	-- copy url
	keymap(
		"n",
		"<Leader>gy",
		'<cmd>lua require"gitlinker".get_buf_range_url("n", {action_callback = function(url) '
			.. 'local file_url = url:match("^(.-)#") or url;'
			.. 'require("gitlinker.actions").copy_to_clipboard(file_url); '
			.. "end})<cr><ESC>",
		{ remap = true, silent = true }
	)
	keymap(
		"v",
		"gy",
		'<cmd>lua require"gitlinker".get_buf_range_url("v", {action_callback = require("gitlinker.actions").copy_to_clipboard})<cr><ESC>',
		{ remap = true, silent = true }
	)

	-- copilot
	keymap("i", "<C-g>d", "<Plug>(copilot-dismiss)", { noremap = true })
	keymap("i", "<C-g>n", "<Plug>(copilot-next)", { noremap = true })
	keymap("i", "<C-g>p", "<Plug>(copilot-previous)", { noremap = true })
	keymap("i", "<C-g>w", "<Plug>(copilot-accept-word)", { noremap = true })
	keymap("i", "<C-g>a", 'copilot#Accept("")', {
		expr = true,
		noremap = true,
		silent = true,
	})
	-- copilot chat
	-- (Copilot Chat Buffer) chat with Copilot using the entire buffer content
	keymap(
		"n",
		"<Leader>cc",
		'<cmd>lua require("plugins/copilot-chat.utils").copilotChatBuffer()<cr>',
		{ noremap = true, silent = true }
	)
	-- (Copilot Chat Selection) chat with Copilot using the selected content
	keymap(
		"v",
		"<Leader>cc",
		'<cmd>lua require("plugins/copilot-chat.utils").copilotChatSelection()<cr>',
		{ noremap = true, silent = true }
	)
	keymap("n", "<Leader>ct", "<cmd>CopilotChatToggle<cr>", { noremap = true, silent = true })
	-- (Copilot Chat Prompt) display the action prompt using telescope
	keymap(
		"n",
		"<Leader>cl",
		'<cmd>lua require("plugins/copilot-chat.utils").showCopilotChatActionPrompt()<cr>',
		{ noremap = true, silent = true }
	)
	keymap(
		"v",
		"<Leader>cl",
		'<cmd>lua require("plugins/copilot-chat.utils").showCopilotChatActionPromptVisualSelection()<cr>',
		{ noremap = true, silent = true }
	)
	-- (Copilot Chat Help) display the action help using telescope
	keymap(
		"n",
		"<Leader>ch",
		'<cmd>lua require("plugins/copilot-chat.utils").showCopilotChatActionHelp()<cr>',
		{ noremap = true, silent = true }
	)
	-- (Copilot Chat Reset) reset the Copilot chat content
	keymap(
		"n",
		"<Leader>cr",
		'<cmd>lua require("plugins/copilot-chat.utils").copilotChatReset()<cr>',
		{ noremap = true, silent = true }
	)

	-- comment/uncomment
	keymap("n", "<C-/>", "gcc", { remap = true })
	keymap("x", "<C-/>", "gc", { remap = true })

	-- bufferline
	keymap("n", "<C-b>c", "<CMD>bdelete!<CR>", { noremap = true, silent = true })
	keymap("n", "<C-b>d", "<CMD>BufferLinePickClose<CR>", { noremap = true, silent = true })
	keymap("n", "<C-b>s", "<CMD>BufferLinePick<CR>", { noremap = true, silent = true })
	keymap("n", "¬", "<CMD>BufferLineCycleNext<CR>", { noremap = true, silent = true }) -- <A-l>
	keymap("n", "<A-l>", "<CMD>BufferLineCycleNext<CR>", { noremap = true, silent = true })
	keymap("n", "˙", "<CMD>BufferLineCyclePrev<CR>", { noremap = true, silent = true }) -- <A-h>
	keymap("n", "<A-h>", "<CMD>BufferLineCyclePrev<CR>", { noremap = true, silent = true })
	keymap("n", "˚", "<CMD>BufferLineMoveNext<CR>", { noremap = true, silent = true }) -- <A-k>
	keymap("n", "<A-k>", "<CMD>BufferLineMoveNext<CR>", { noremap = true, silent = true })
	keymap("n", "∆", "<CMD>BufferLineMovePrev<CR>", { noremap = true, silent = true }) -- <A-j>
	keymap("n", "<A-j>", "<CMD>BufferLineMovePrev<CR>", { noremap = true, silent = true })

	-- lsp
	-- finder
	keymap("n", "<Leader>fi", "<cmd>Lspsaga finder tyd+ref+imp+def<CR>", { silent = true })
	-- reference
	keymap("n", "<Leader>rf", "<cmd>Lspsaga finder ref<CR>", { silent = true })
	-- definition
	keymap("n", "<Leader>df", "<Cmd>tab lua vim.lsp.buf.definition()<CR>", { silent = true })
	-- close unused navigation window
	keymap("n", "<Leader>dd", "<C-w>j:q<CR>", { silent = true })
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

	-- format
	keymap("n", "<Leader>fmt", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", { noremap = true, silent = true })

	-- float terminal
	keymap({ "n", "t" }, "ƒ", "<cmd>Lspsaga term_toggle<CR>", { silent = true }) -- <A-f>
	keymap({ "n", "t" }, "<A-f>", "<cmd>Lspsaga term_toggle<CR>", { silent = true })

	-- session
	keymap("n", "<C-s>", ":SessionSave<CR>", { noremap = true })
	keymap("n", "<CS-S>", "<cmd>Telescope session-lens search_session<CR>", { noremap = true, silent = true })
end

-- highlight mark setting
keymap({ "n", "x" }, "<Leader>m", "<Plug>(quickhl-manual-this)", { noremap = true })
keymap({ "n", "x" }, "<Leader>M", "<Plug>(quickhl-manual-reset)", { noremap = true })

-- disable lightspeed
-- keymap({ "n", "v" }, "s", "s", { noremap = true })
-- keymap({ "n", "v" }, "S", "S", { noremap = true })

-- CamelCaseMotion
keymap({ "n", "v" }, "w", "<Plug>CamelCaseMotion_w", { noremap = true })
keymap({ "n", "v" }, "b", "<Plug>CamelCaseMotion_b", { noremap = true })
keymap({ "n", "v" }, "e", "<Plug>CamelCaseMotion_e", { noremap = true })
keymap({ "n", "v" }, "ge", "<Plug>CamelCaseMotion_ge", { noremap = true })
