local map = vim.keymap.set

vim.g.mapleader = " "
map('n', '<leader>o', ':update<CR> :source<CR>')
map('n', '<leader>s', ':write<CR>')
map('n', '<leader>q', ':quit<CR>')
-- map({ 'n', 'v', 'x' }, '<leader>s', ':e #<CR>')
map({ 'n', 'v', 'x' }, '<leader>O', ':sf #<CR>')
map('n', '<leader>x', ':bd<CR>', { desc = "Close buffer" })
map("n", "K", vim.lsp.buf.hover, { desc = "LSP Hover" })

map('n', '<leader>o', ':update<CR> :source<CR>')
map('n', '<leader>s', ':write<CR>')
map('n', '<leader>q', ':quit<CR>')
-- map({ 'n', 'v', 'x' }, '<leader>s', ':e #<CR>')
map({ 'n', 'v', 'x' }, '<leader>O', ':sf #<CR>')
map('n', '<leader>x', ':bd<CR>', { desc = "Close buffer" })
map("n", "K", vim.lsp.buf.hover, { desc = "LSP Hover" })

map("n", "<esc>", "<cmd>noh<CR>")
map('n', '<leader>f', ":Pick files<CR>")
map('n', '<leader>h', ":Pick help<CR>")
map('n', '<leader>e', ":Oil<CR>")
map('t', '', "")
map('t', '', "")
map('n', '<leader>lf', vim.lsp.buf.format)
map("n", "}", "}zz")
map("n", "{", "{zz")

-- delete not cut
map({ "n", "v" }, "d", "\"_d")
map({ "n", "v" }, "D", "\"_D")
map({ "n", "v" }, "X", "dd")

map({ "n" }, "<space>a", "mzA<space><esc>p`z", { desc = "paste to the end of line" })
map("n", "<leader>za", 'ggVG"+y', { desc = "Yank entire buffer" })

-- Search/replace
map({ "n", "v" }, "<leader>rw", ":%s/<C-r><C-w>//g<Left><Left>", { desc = "Replace word under cursor" })

-- Formatting
map("n", "<leader>al", "<cmd>lua vim.lsp.buf.format()<CR>", { desc = "Format with LSP" })


-- Spell control
-- map("n", "<leader>gg", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "Show grammar issues" })
-- map("n", "<leader>ss", "<cmd>set spell!<CR>", { desc = "Toggle spell check" })
-- map("n", "<leader>se", "<cmd>set spelllang=en_us<CR>", { desc = "English spell" })
-- map("n", "<leader>sd", "<cmd>set spelllang=de<CR>", { desc = "German spell" })
-- map("n", "z=", "z=1<CR>", { silent = true, desc = "Accept 1st suggestion" })


map('n', '<leader>>', ':vertical resize +5<CR>', { desc = 'Increase split width' })
map('n', '<leader><', ':vertical resize -5<CR>', { desc = 'Decrease split width' })
map('n', '<leader>+', ':resize +5<CR>', { desc = 'Increase split height' })
map('n', '<leader>-', ':resize -5<CR>', { desc = 'Decrease split height' })

map('n', '<leader>vs', ':vsplit<CR>', { desc = 'Vertical split' })
map('n', '<leader>hs', ':split<CR>', { desc = 'Horizontal split' })

map('n', '<C-h>', '<C-w>h', { desc = 'Move to left split' })
map('n', '<C-j>', '<C-w>j', { desc = 'Move to lower split' })
map('n', '<C-k>', '<C-w>k', { desc = 'Move to upper split' })
map('n', '<C-l>', '<C-w>l', { desc = 'Move to right split' })
map('n', '<C-Left>', '<C-w>h', { desc = 'Move to left split' })
map('n', '<C-Down>', '<C-w>j', { desc = 'Move to lower split' })
map('n', '<C-Up>', '<C-w>k', { desc = 'Move to upper split' })
map('n', '<C-Right>', '<C-w>l', { desc = 'Move to right split' })

