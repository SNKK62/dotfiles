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

-- brackets and quotes
keymap('i', '{', '{}<LEFT>', { noremap = true })
keymap('i', '[', '[]<LEFT>', { noremap = true })
keymap('i', '(', '()<LEFT>', { noremap = true })
keymap('i', '"', '""<LEFT>', { noremap = true })
keymap('i', '\'', '\'\'<LEFT>', { noremap = true })
keymap('i', '`', '``<LEFT>', { noremap = true })

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

-- swap paste keymaps
keymap({ 'n', 'v' }, 'p', 'P', { noremap = true })
keymap({ 'n', 'v' }, 'P', 'p', { noremap = true })

-- fern
keymap('n', '<C-f>', ':Fern . -drawer -reveal=% -toggle -width=33<CR>', { noremap = true })

-- telescope
local builtin = require('telescope.builtin')
keymap('n', '<C-p>', builtin.find_files, {})
keymap('n', '<C-g>', builtin.live_grep, {})
keymap('n', '<C-b>g', builtin.buffers, {})

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


