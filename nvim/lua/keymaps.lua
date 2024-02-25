local keymap = vim.keymap.set

vim.g.mapleader = " "

-- cursor motion
keymap({ 'n', 'v' }, '<C-j>', '15j', { noremap = true })
keymap({ 'n', 'v' }, '<C-k>', '15k', { noremap = true })
keymap({ 'n', 'v' }, '<C-h>', '10h', { noremap = true })
keymap({ 'n', 'v' }, '<C-l>', '10l', { noremap = true })

keymap({ 'n', 'v' }, ';;', '$', { noremap = true })
keymap({ 'n', 'v' }, '\'\'', '^', { noremap = true })
keymap('i', '<C-;><C-;>', '<C-o>$', { noremap = true })
keymap('i', '<C-\'><C-\'>', '<C-o>^', { noremap = true })

keymap('i', '<C-j>', '<DOWN>', { noremap = true })
keymap('i', '<C-k>', '<UP>', { noremap = true })
keymap('i', '<C-h>', '<LEFT>', { noremap = true })
keymap('i', '<C-l>', '<RIGHT>', { noremap = true })

-- substitution
keymap('n', '<Leader>repg', ':%s//g<LEFT><LEFT>', { noremap = true })
keymap('n', '<Leader>repc', ':%s//gc<LEFT><LEFT><LEFT>', { noremap = true })

-- terminal mode setting
keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true })
keymap('n', 'tt', '<Cmd>terminal<CR>', { noremap = true, silent = true })
keymap('n', 'tx', '<Cmd>belowright new<CR><Cmd>terminal<CR>', { noremap = true, silent = true })
vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "*",
    callback = function()
        vim.cmd('startinsert')
        vim.opt_local.relativenumber = false
        vim.opt_local.number = false
    end
})

-- filer (neo-tree)
keymap(
    'n',
    '<C-f>',
    function()
      require("neo-tree.command").execute({
        toggle = true,
        source = "filesystem",
        position = "left",
      })
    end
)
keymap(
    'n',
    '<CS-G>',
    function()
      require("neo-tree.command").execute({
        toggle = true,
        source = "git_status",
        position = "left",
      })
    end
)
keymap(
    'n',
    '<CS-B>',
    function()
      require("neo-tree.command").execute({
        toggle = true,
        source = "buffers",
        position = "left",
      })
    end
)

-- sideber
keymap(
    'n',
    '<CS-F>',
    function()
        require("sidebar-nvim").toggle()
    end
)

-- telescope
local builtin = require('telescope.builtin')
keymap('n', '<C-p>', builtin.find_files, {})
keymap('n', '<C-g>', builtin.live_grep, {})
keymap('n', '<C-b>g', builtin.buffers, {})

-- treesitter-context
keymap('n', '<Leader>tc', '<Cmd>TSContextToggle<CR>', { noremap = true, silent = true })

-- iswap
keymap('n', '<Leader>sw', '<Cmd>ISwap<CR>', { noremap = true, silent = true })
keymap('n', '<Leader>sn', '<Cmd>ISwapNode<CR>', { noremap = true, silent = true })

-- git
keymap('n', '<Leader><C-a>', ':Gwrite<CR>', { noremap = true })
keymap('n', '<Leader>ga', ':!git add<Space>', { noremap = true })
keymap('n', '<Leader>gc', ':!git commit -m \'\'<LEFT>', { noremap = true })
keymap('n', '<Leader><C-p>', ':!git push<CR>', { noremap = true })
keymap('n', '<Leader>gp', ':!git push -u origin<Space>', { noremap = true })
keymap('n', '<Leader>gd', ':Gdiff<CR>', { noremap = true })
keymap('n', '<Leader>gb', ':Git blame<CR>', { noremap = true })
keymap('n', '<Leader>gs', ':Git status<CR>', { noremap = true })
keymap('n', '<Leader>ghp', ':GitGutterPrevHunk<CR>', { noremap = true })
keymap('n', '<Leader>ghn', ':GitGutterNextHunk<CR>', { noremap = true })
keymap('n', '<Leader>ghl', ':GitGutterLineHighlightsToggle<CR>', { noremap = true })
keymap('n', '<Leader>gpr', ':GitGutterPreviewHunk<CR>', { noremap = true })

-- copilot
keymap('i', '<C-g>d', '<Plug>(copilot-dismiss)', { noremap = true })
keymap('i', '<C-g>n', '<Plug>(copilot-next)', { noremap = true })
keymap('i', '<C-g>p', '<Plug>(copilot-previous)', { noremap = true })
keymap('i', '<C-g>w', '<Plug>(copilot-accept-word)', { noremap = true })
keymap('i', '<C-g>l', '<Plug>(copilot-accept-line)', { noremap = true })

-- comment/uncomment
keymap('n', '<C-/>', '<C-_><C-_>', { remap = true })
keymap('i', '<C-/>', '<C-_><C-_>', { remap = true })
keymap('v', '<C-/>', 'gc', { remap = true})

-- barbar
-- switch buffer
keymap('n', '<C-b>h', '<Cmd>BufferPrevious<CR>', { noremap = true, silent = true })
keymap('n', '˙', '<Cmd>BufferPrevious<CR>', { noremap = true, silent = true }) -- <A-h>
keymap('n', '<C-b>l', '<Cmd>BufferNext<CR>', { noremap = true, silent = true })
keymap('n', '¬', '<Cmd>BufferNext<CR>', { noremap = true, silent = true }) -- <A-l>
-- reorder buffer
keymap('n', '<C-b>j', '<Cmd>BufferMovePrevious<CR>', { noremap = true, silent = true })
keymap('n', '∆', '<Cmd>BufferMovePrevious<CR>', { noremap = true, silent = true }) -- <A-j>
keymap('n', '<C-b>k', '<Cmd>BufferMoveNext<CR>', { noremap = true, silent = true })
keymap('n', '˚', '<Cmd>BufferMoveNext<CR>', { noremap = true, silent = true }) -- <A-k>
-- pin/unpin buffer
keymap('n',  '<C-b>p', '<Cmd>BufferPin<CR>', { noremap = true, silent = true })
-- close buffer
keymap('n',  '<C-b>c', '<Cmd>BufferClose<CR>', { noremap = true, silent = true })
-- restore buffer
keymap('n',  '<C-b>z', '<Cmd>BufferRestore<CR>', { noremap = true, silent = true })
-- magic buffer-picking mode
keymap('n',  '<C-b>s', '<Cmd>BufferPick<CR>', { noremap = true, silent = true })
keymap('n',  '<C-b>d', '<Cmd>BufferPickDelete<CR>', { noremap = true, silent = true })

-- mark setting
keymap({ 'n', 'x' }, '<Leader>m', '<Plug>(quickhl-manual-this)', { noremap = true })
keymap({ 'n', 'x' }, '<Leader>M', '<Plug>(quickhl-manual-reset)', { noremap = true })

-- lsp
-- finder
keymap("n", "<Leader>fi", "<cmd>Lspsaga finder<CR>", { silent = true })
keymap("n", "<Leader>ty", "<cmd>Lspsaga finder tyd+ref+imp+def<CR>", { silent = true })
-- definition
keymap("n", "<Leader>df", "<cmd>Lspsaga peek_definition<CR>", { silent = true })
-- rename
keymap("n", "<Leader>rn", "<cmd>Lspsaga rename<CR>", { silent = true })
-- document
keymap("n", "K", "<cmd>Lspsaga hover_doc ++quiet<CR>", { silent = true })
-- diagnostics
keymap("n", "<Leader>dl", "<cmd>Lspsaga show_line_diagnostics<CR>", { silent = true })
keymap("n", "<Leader>dp", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { silent = true })
keymap("n", "<Leader>dn", "<cmd>Lspsaga diagnostic_jump_next<CR>", { silent = true })
keymap("n", "<Leader>db", "<cmd>Lspsaga show_buf_diagnostics<CR>", { silent = true })
keymap("n", "<Leader>dw", "<cmd>Lspsaga show_workspace_diagnostics<CR>", { silent = true })

keymap("n", "<leader>xx", function() require("trouble").toggle() end)
keymap("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end)
keymap("n", "<leader>xd", function() require("trouble").toggle("document_diagnostics") end)
keymap("n", "<leader>xq", function() require("trouble").toggle("quickfix") end)
keymap("n", "<leader>xl", function() require("trouble").toggle("loclist") end)
keymap("n", "<leader>xr", function() require("trouble").toggle("lsp_references") end)
-- action
keymap({"n","v"}, "<Leader>ac", "<cmd>Lspsaga code_action<CR>", { silent = true })
-- float terminal
keymap({'n','t'}, 'ƒ', '<cmd>Lspsaga term_toggle<CR>', { silent = true }) -- <A-f>
