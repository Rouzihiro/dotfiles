local map = vim.keymap.set
vim.g.mapleader = " "

map({ "n", "v", "x" }, ";", ":", { desc = "Self explanatory" })
map({ "n", "v", "x" }, ":", ";", { desc = "Self explanatory" })
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

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

map('n', '<leader>x', '<Cmd>quit<CR>')
map('n', '<C-q>', '<Cmd>bd!<CR>', { desc = "Force close buffer" })

map("n", "<esc>", "<cmd>noh<CR>")
map('n', '<leader>pp', "<Cmd>Pick files<CR>")
map('n', '<leader>ph', "<Cmd>Pick help<CR>")
map('n', '<leader>pb', "<Cmd>Pick buffers<CR>")
map({ "n", "v", "x" }, "<leader>lf", vim.lsp.buf.format, { desc = "Format current buffer" })
map('i', '<c-Space>', function() vim.lsp.completion.get() end)
map('n', '<leader>tt', '<Cmd>Open .<CR>')
map('n', '<leader>nc', '<Cmd>e $MYVIMRC<CR>')
map('n', '<leader>nn', '<Cmd>e ~/.config/nvim/lua/keymaps.lua<CR>')
map('n', '<leader>zz', '<Cmd>e ~/.config/zsh/.aliases<CR>')
map('n', '<leader>zc', '<Cmd>e ~/.config/zsh/.zshrc<CR>')
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

-- map({ "n" }, "<leader>A", "mzA<space><esc>p`z", { desc = "paste to the end of line" })
map("n", "<leader>za", 'ggVG"+y', { desc = "Yank entire buffer" })

map({ "n", "v" }, "<leader>rw",
	":%s/<C-r><C-w>//g<Left><Left>",
	{ desc = "Replace word under cursor" })

map({ "n", "v" }, "<leader>rW",
	":%s/<C-r><C-w>//gc<Left><Left><Left>",
	{ desc = "Replace word under cursor with confirmation" })

map({ 'n', 'v' }, '<leader>c', '1z=', { desc = "Correct last misspelled word" })

-- Formatting
map("n", "<leader>al", "<cmd>lua vim.lsp.buf.format()<CR>", { desc = "Format with LSP" })
map('n', '<leader>>', '<Cmd>vertical resize +5<CR>', { desc = 'Increase split width' })
map('n', '<leader><', '<Cmd>vertical resize -5<CR>', { desc = 'Decrease split width' })
map('n', '<leader>+', '<Cmd>resize +5<CR>', { desc = 'Increase split height' })
map('n', '<leader>-', '<Cmd>resize -5<CR>', { desc = 'Decrease split height' })

-- Telescope
local builtin = require("telescope.builtin")
map("n", "<leader>o", builtin.oldfiles, { desc = "Recent files" })
map({ "n" }, "<leader>f", builtin.find_files, { desc = "Telescope live grep" })
map({ "n" }, "<leader>g", builtin.live_grep, { desc = "Telescope live grep" })
map({ "n" }, "<leader>b", builtin.buffers, { desc = "Telescope buffers" })
map({ "n" }, "<leader>si", builtin.grep_string, { desc = "Telescope live string" })
map({ "n" }, "<leader>so", builtin.oldfiles, { desc = "Recent files" })
map({ "n" }, "<leader>sh", builtin.help_tags, { desc = "Telescope help tags" })
map({ "n" }, "<leader>sm", builtin.man_pages, { desc = "Telescope man pages" })
map({ "n" }, "<leader>sr", builtin.lsp_references, { desc = "Telescope tags" })
map({ "n" }, "<leader>st", builtin.builtin, { desc = "Telescope tags" })
map({ "n" }, "<leader>sd", builtin.registers, { desc = "Telescope tags" })
map({ "n" }, "<leader>sc", builtin.git_bcommits, { desc = "Telescope tags" })
map({ "n" }, "<leader>se", "<cmd>Telescope env<cr>", { desc = "Telescope tags" })
map({ "n" }, "<leader>sa", require("actions-preview").code_actions)

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

-- LSP actions
map('n', '<leader>lr', vim.lsp.buf.rename, { desc = "Rename symbol" })
map('n', '<leader>la', vim.lsp.buf.code_action, { desc = "Code actions" })
map('n', '<leader>lf', function() vim.lsp.buf.format({ async = true }) end, { desc = "Format buffer" })
map('n', '<leader>ld', vim.lsp.buf.definition, { desc = "Go to definition" })
map('n', '<leader>lt', vim.lsp.buf.type_definition, { desc = "Go to type definition" })
map('n', '<leader>li', vim.lsp.buf.implementation, { desc = "Go to implementation" })
map('n', '<leader>lR', vim.lsp.buf.references, { desc = "Show references" })
map('n', '<leader>ls', vim.lsp.buf.document_symbol, { desc = "Document symbols" })
map('n', '<leader>lS', vim.lsp.buf.workspace_symbol, { desc = "Workspace symbols" })
map('n', '<leader>lh', vim.lsp.buf.hover, { desc = "Hover docs" })
map('n', '<leader>lH', vim.lsp.buf.signature_help, { desc = "Signature help" })
map('n', '<leader>lE', vim.diagnostic.open_float, { desc = "Show error under cursor" })
map('n', '<leader>lq', vim.diagnostic.setloclist, { desc = "Quickfix diagnostics" })

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

map("n", "<leader>ll", ":copen<CR>", { silent = true })

for i = 1, 9 do
	map('n', '<leader>' .. i, ':cc ' .. i .. '<CR>', { noremap = true, silent = true })
end

vim.api.nvim_create_autocmd("BufWinEnter", {
	pattern = "*",
	group = vim.api.nvim_create_augroup("qf", { clear = true }),
	callback = function()
		if vim.bo.buftype == "quickfix" then
			map("n", "<leader>ll", ":ccl<cr>", { buffer = true, silent = true })
			map("n", "dd", function()
				local idx = vim.fn.line('.')
				local qflist = vim.fn.getqflist()
				table.remove(qflist, idx)
				vim.fn.setqflist(qflist, 'r')
			end, { buffer = true })
		end
	end,
})

-- Spell control
-- map("n", "<leader>gg", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "Show grammar issues" })
-- map("n", "<leader>ss", "<cmd>set spell!<CR>", { desc = "Toggle spell check" })
-- map("n", "<leader>se", "<cmd>set spelllang=en_us<CR>", { desc = "English spell" })
-- map("n", "<leader>sd", "<cmd>set spelllang=de<CR>", { desc = "German spell" })
-- map("n", "z=", "z=1<CR>", { silent = true, desc = "Accept 1st suggestion" })
