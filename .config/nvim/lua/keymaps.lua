local map = vim.keymap.set

vim.g.mapleader = " "

map("n", "<leader>e", function()
	vim.cmd("Oil --float " .. vim.loop.cwd())
end, { desc = "Open Oil floating file manager" })

map('n', '<leader>u', ':update<CR> :source<CR>')
map('n', '<leader>s', ':write<CR>')
-- map({ 'n', 'v', 'x' }, '<leader>s', ':e #<CR>')
map('n', '<leader>q', ':bd<CR>', { desc = "Close buffer" })
map("n", "K", vim.lsp.buf.hover, { desc = "LSP Hover" })

map('n', '<leader>x', ':quit<CR>')
map('n', '<C-q>', '<Cmd>bd!<CR>', { desc = "Force close buffer" })

map("n", "<esc>", "<cmd>noh<CR>")
map('n', '<leader>p', ":Pick files<CR>")
map('n', '<leader>h', ":Pick help<CR>")
map('n', '<leader>lf', vim.lsp.buf.format)
map("n", "}", "}zz")
map("n", "{", "{zz")

-- delete not cut
map({ "n", "v" }, "d", "\"_d")
map({ "n", "v" }, "D", "\"_D")
map({ "n", "v" }, "X", "dd")

map({ "n" }, "<leader>R", ":display<CR>", { desc = "Show registers" })

for i = 0, 9 do
  map('n', '<leader>r' .. i, '"' .. i .. 'p', opts)
end

map({ "n" }, "<space>a", "mzA<space><esc>p`z", { desc = "paste to the end of line" })
map("n", "<leader>za", 'ggVG"+y', { desc = "Yank entire buffer" })

-- Search/replace
map({ "n", "v" }, "<leader>C", ":%s/<C-r><C-w>//g<Left><Left>", { desc = "Replace word under cursor" })

map({ "n", "v" }, "<leader>c", ":%s/<C-r><C-w>//gc<Left><Left><Left>", { desc = "Replace word under cursor with confirmation" })

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

-- Telescope
local builtin = require("telescope.builtin")
map("n", "<leader>o", builtin.oldfiles, { desc = "Recent files" })
map("n", "<leader>f", builtin.find_files, { desc = "Find files" })
map("n", "<leader>b", builtin.buffers, { desc = "Buffers" })
map("n", "<leader>H", builtin.help_tags, { desc = "Help tags" })

map('n', '<leader>g', builtin.live_grep, { desc = '[F]ind by [G]rep (search content)' })
map('n', '<leader>w', function()
	builtin.grep_string({ search = vim.fn.expand('<cword>') })
end, { desc = '[F]ind current [W]ord' })
map('n', '<leader>W', function()
	builtin.live_grep({ search_dirs = { vim.fn.input('Directory: ') } })
end, { desc = '[F]ind in [D]irectory' })

-- Open file in vertical split
map('n', '<leader>v', ':vsplit<CR>:Telescope find_files<CR>', { desc = 'Find file (vertical split)' })
-- Open file in horizontal split
map('n', '<leader>V', ':split<CR>:Telescope find_files<CR>', { desc = 'Find file (horizontal split)' })

-- Enhanced Nvim-tree Keymaps
-- map('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'Toggle Explorer' })
-- map('n', '<leader>E', ':NvimTreeFindFile<CR>', { desc = 'Reveal Current File' })


-- vim.api.nvim_set_keymap('i', '<C-Space>', "cmp.complete()", { noremap = true, expr = true, silent = true })
