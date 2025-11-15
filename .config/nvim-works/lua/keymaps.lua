local map = vim.keymap.set
vim.g.mapleader = " "

map({ "n", "v", "x" }, ";", ":", { desc = "Self explanatory" })
map({ "n", "v", "x" }, ":", ";", { desc = "Self explanatory" })
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

local builtin = require("telescope.builtin")
map("n", "<leader>o", builtin.oldfiles, { desc = "Recent files" })

-- window management
-- map("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
-- map("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
map("n", "<leader>fe", "<C-w>=", { desc = "Make splits equal size" })
map("n", "<leader>fx", "<cmd>close<CR>", { desc = "Close current split" })
map('n', '<leader>B', '<Cmd>e #<CR>', { desc = "Edit the alternate file" })
map('n', '<leader>fh', '<Cmd>bot sf #<CR>', { desc = "Horizontal split with alternate file" })
map('n', '<leader>fv', '<Cmd>vert belowright sf #<CR>', { desc = "Vertical split with alternate file" })

-- tabs
map("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
map("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
map("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
map("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
map("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })
map("n", "<leader>ta", "<cmd>tab all<CR>", { desc = "Open all current NVIM files in their own tab" })

-- map({ "n" }, "<leader>e", "<cmd>Oil<CR>", { desc = "Open Oil file manager" })

 map("n", "<leader>e", function()
	vim.cmd("Oil --float " .. vim.loop.cwd())
  end, { desc = "Open Oil floating file manager" })
 
map({ "n", "v", "x" }, "<leader>u", "<Cmd>source %<CR>", { desc = "Source " .. vim.fn.expand("$MYVIMRC") })
map({ "n", "v", "x" }, "<leader>U", "<Cmd>restart<CR>", { desc = "Restart vim." })
map({ "n", "v", "x" }, "<C-s>", [[:s/\V]], { desc = "Enter substitue mode in selection" })
map({ "v", "x", "n" }, "<C-y>", '"+y', { desc = "System clipboard yank." })

map('n', '<leader>w', '<Cmd>write<CR>')
map({ "n" }, "<leader>q", "<Cmd>bd<CR>", { desc = "Close buffer" })
map({ "n" }, "<leader>Q", "<Cmd>:wqa<CR>", { desc = "Quit all buffers and write." })
map("n", "K", vim.lsp.buf.hover, { desc = "LSP Hover" })

-- map('n', '<leader>x', '<Cmd>quit<CR>')
map('n', '<C-q>', '<Cmd>bd!<CR>', { desc = "Force close buffer" })

map("n", "<esc>", "<cmd>noh<CR>")
map({ "n", "v", "x" }, "<Leader>lf", vim.lsp.buf.format, { desc = "Format current buffer" })
map('i', '<c-Space>', function() vim.lsp.completion.get() end)
map('n', '<leader>tt', '<Cmd>Open .<CR>')
map('n', '<leader>vc', '<Cmd>e $MYVIMRC<CR>')
map('n', '<leader>vv', '<Cmd>e ~/.config/nvim/lua/keymaps.lua<CR>')
map('n', '<leader>zc', '<Cmd>e ~/.config/zsh/.aliases<CR>')
map('n', '<leader>zz', '<Cmd>e ~/.config/zsh/.zshrc<CR>')
map('n', '<leader>zf', '<Cmd>e ~/.config/zsh/.aliases-functions<CR>')
map("n", "}", "}zz")
map("n", "{", "{zz")

-- delete not cut
map({ "n", "v" }, "d", "\"_d")
map({ "n", "v" }, "D", "\"_D")
map({ "n", "v" }, "X", "dd")
map("n", "<leader>y", "yt#", { noremap = true, silent = true })

map({ "n" }, "<leader>R", "<Cmd>display<CR>", { desc = "Show registers" })

for i = 0, 9 do
	map('n', '<leader>r' .. i, '"' .. i .. 'p', opts)
end

map({ "n" }, "P", "mzA<space><esc>p`z", { desc = "paste to the end of line" })
map({"n"}, "A", "mzI<space><esc>P`z", { desc = "Paste at start of line" })
map("n", "<leader>za", 'ggVG"+y', { desc = "Yank entire buffer" })

map({ "n", "v" }, "<leader>rw",
	":%s/<C-r><C-w>//g<Left><Left>",
	{ desc = "Replace word under cursor" })

map({ "n", "v" }, "<leader>rW",
	":%s/<C-r><C-w>//gc<Left><Left><Left>",
	{ desc = "Replace word under cursor with confirmation" })

map({ 'n', 'v' }, '<leader>c', '1z=', { desc = "Correct last misspelled word" })

-- Open file in vertical split
map('n', '<leader>v', '<Cmd>vsplit<CR><Cmd>Telescope find_files<CR>', { desc = 'Find file (vertical split)' })

-- Open file in horizontal split
map('n', '<leader>V', '<Cmd>split<CR><Cmd>Telescope find_files<CR>', { desc = 'Find file (horizontal split)' })

-- Error navigation and analysis
map('n', '<leader>le', function() vim.diagnostic.open_float({ on_jump = function() end }) end,
	{ desc = "Show error under cursor" })
map('n', '<leader>lq', function() vim.diagnostic.setqflist() end, { desc = "Show all errors in quickfix" })

map('n', ']]', function()
	vim.diagnostic.jump({ count = 1, on_jump = function() end })
end, { desc = "Next diagnostic" })

map('n', '[[', function()
	vim.diagnostic.jump({ count = -1, on_jump = function() end })
end, { desc = "Prev diagnostic" })

map("n", "<leader>X", function()
	local file = vim.fn.expand("%")
	if vim.fn.getfsize(file) > 0 then
		vim.fn.system({ "chmod", "+x", file })
		print("Made " .. vim.fn.expand("%:t") .. " executable")
	end
end, { desc = "Make current file executable" })

-- automatically make .sh files executable on save
vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*.sh",
	callback = function()
		local file = vim.fn.expand("%")
		if vim.fn.getfsize(file) > 0 then
			vim.fn.system({ "chmod", "+x", file })
		end
	end,
})

-- Spell control
-- map("n", "<leader>gg", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "Show grammar issues" })
-- map("n", "<leader>ss", "<cmd>set spell!<CR>", { desc = "Toggle spell check" })
-- map("n", "<leader>se", "<cmd>set spelllang=en_us<CR>", { desc = "English spell" })
-- map("n", "<leader>sd", "<cmd>set spelllang=de<CR>", { desc = "German spell" })
-- map("n", "z=", "z=1<CR>", { silent = true, desc = "Accept 1st suggestion" })
