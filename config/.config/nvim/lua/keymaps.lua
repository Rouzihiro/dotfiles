local map = vim.keymap.set
vim.g.mapleader = " "

-- =====================
-- General
-- =====================
map("n", "<esc>", "<cmd>noh<CR>")
map({ "n", "v", "x" }, ";", ":", { desc = "Swap ; and :" })
map({ "n", "v", "x" }, ":", ";", { desc = "Swap : and ;" })
map("n", "n", "nzzzv", { desc = "Next search result centered" })
map("n", "N", "Nzzzv", { desc = "Previous search result centered" })

-- Make 'c' (change) not yank the deleted text (send to black hole register "_")
map("n", "c", '"_c', { desc = "Change without yanking" })

-- =====================
-- Window management
-- =====================
map("n", "<leader>s|", "<C-w>v", { desc = "Split window vertically" })
map("n", "<leader>s-", "<C-w>s", { desc = "Split window horizontally" })
map("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })
map('n', '<leader>sh', '<Cmd>bot sf #<CR>', { desc = "Horizontal split with alternate file" })
map('n', '<leader>sv', '<Cmd>vert belowright sf #<CR>', { desc = "Vertical split with alternate file" })

-- =====================
-- Buffes
-- =====================
map("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<C-w>w", { desc = "Cycle through splits" })

-- map("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })

-- =====================
-- File manager (Broot)
-- =====================
map("n", "<leader>bc", function()
    require('broot').open("$HOME/.config")
end, { desc = "Open broot in ~/.config" })

map("n", "<leader>e", function()
    require('broot').open("$HOME/.config")
end, { desc = "Open broot in ~/.config" })

map("n", "<leader>bf", function()
    require('broot').open()
end, { desc = "Open broot in current directory" })

map("n", "<leader>bh", function()
    require('broot').open("~")
end, { desc = "Open broot in home" })

map("n", "<leader>bn", function()
    require('broot').open("~/.config/nvim")
end, { desc = "Open broot in nvim config" })
-- =====================
-- File path helpers
-- =====================
map("n", "<leader>fa", function() print(vim.fn.expand("%:p")) end, { desc = "Show absolute path" })
map("n", "<leader>ft", function() print(vim.fn.expand("%:t")) end, { desc = "Show filename" })
map("n", "<leader>fr", function() print(vim.fn.fnamemodify(vim.fn.expand("%"), ":.")) end, { desc = "Show relative path" })
map("n", "<leader>fy", function()
    local path = vim.fn.fnamemodify(vim.fn.expand("%"), ":.")
    vim.fn.setreg("+", path)
    print("yanked: " .. path)
end, { desc = "Yank relative path" })
map("n", "<leader>cd", "<cmd>lcd %:p:h<CR>", { desc = "cd to current file's dir" })
map("n", "<leader>gr", function()
    local root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
    if root and root ~= "" then vim.cmd("cd " .. root) end
end, { desc = "cd to git root" })


-- =====================
-- Quickfix
-- =====================
map("n", "<leader>ho", "<cmd>copen<CR>", { desc = "Open quickfix" })
map("n", "<leader>hc", "<cmd>cclose<CR>", { desc = "Close quickfix" })
map("n", "]h", "<cmd>cnext<CR>", { desc = "Next quickfix item" })
map("n", "[h", "<cmd>cprev<CR>", { desc = "Prev quickfix item" })

-- =====================
-- Reload / Source
-- =====================
map({ "n", "v", "x" }, "<leader>u", "<Cmd>source %<CR>", { desc = "Source current file" })
map({ "n", "v", "x" }, "<leader>U", "<Cmd>restart<CR>", { desc = "Restart Neovim" })

-- =====================
-- Editing
-- =====================
map({ "n", "v", "x" }, "<C-s>", [[:s/\V]], { desc = "Enter substitute mode" })
map({ "v", "x", "n" }, "<C-y>", '"+y', { desc = "Yank to system clipboard" })
map({ "n", "v" }, "d", "\"_d", { desc = "Delete without cutting" })
map({ "n", "v" }, "D", "\"_D", { desc = "Delete to end of line without cutting" })
map("n", "x", "\"_x", { desc = "Delete character without cutting" })
map("n", "X", "d$", { desc = "Cut to end of line" }) 
map("n", "<leader>y", "yt#", { noremap = true, silent = true, desc = "Yank until #" })

map({ "n" }, "P", "mzA<space><esc>p`z", { desc = "Paste to end of line" })
map({"n"}, "A", "mzI<space><esc>P`z", { desc = "Paste at start of line" })
map("n", "<leader>za", 'ggVG"+y', { desc = "Yank entire buffer" })
map({ "n", "v" }, "<leader>rw", ":%s/<C-r><C-w>//g<Left><Left>", { desc = "Replace word under cursor" })
map({ "n", "v" }, "<leader>rW", ":%s/<C-r><C-w>//gc<Left><Left><Left>", { desc = "Replace word with confirmation" })
map({ 'n', 'v' }, '<leader>c', '1z=', { desc = "Correct last misspelled word" })

-- =====================
-- Registers
-- =====================
map({ "n" }, "<leader>R", "<Cmd>display<CR>", { desc = "Show registers" })

for i = 1, 9 do
    map("n", "<leader>p" .. i, '"' .. i .. 'p', { desc = "Paste from register " .. i })
    map("n", "<leader>P" .. i, '"' .. i .. 'P', { desc = "Paste from register " .. i .. " before cursor" })
end

-- =====================
-- Buffer management
-- =====================

map('n', '<leader>w', '<Cmd>write<CR>', { desc = "Save buffer" })
map({ "n" }, "<leader>q", "<Cmd>bd<CR>", { desc = "Close buffer" })
map({ "n" }, "<leader>Q", "<Cmd>:wqa<CR>", { desc = "Write & quit all buffers" })
map('n', '<C-q>', '<Cmd>bd!<CR>', { desc = "Force close buffer" })

-- =====================
-- LSP / Diagnostics
-- =====================
map("n", "K", vim.lsp.buf.hover, { desc = "LSP hover" })
map({ "n", "v", "x" }, "<Leader>lf", vim.lsp.buf.format, { desc = "Format buffer" })

map('n', '<leader>le', function() vim.diagnostic.open_float({ on_jump = function() end }) end, { desc = "Show error under cursor" })
map('n', '<leader>la', function() vim.diagnostic.setqflist() end, { desc = "Show all errors in quickfix" })
map('n', ']]', function() vim.diagnostic.jump({ count = 1, on_jump = function() end }) end, { desc = "Next diagnostic" })
map('n', '[[', function() vim.diagnostic.jump({ count = -1, on_jump = function() end }) end, { desc = "Previous diagnostic" })

-- =====================
-- Misc
-- =====================
map('i', '<c-Space>', function() vim.lsp.completion.get() end, { desc = "Trigger LSP completion" })
map('n', '<leader>tt', '<Cmd>Open .<CR>', { desc = "Open current folder in terminal" })
map('n', '<leader>vc', '<Cmd>e $MYVIMRC<CR>', { desc = "Edit init.lua" })
map('n', '<leader>vv', '<Cmd>e ~/.config/nvim/lua/keymaps.lua<CR>', { desc = "Edit keymaps.lua" })
map('n', '<leader>zc', '<Cmd>e ~/.config/zsh/.aliases<CR>', { desc = "Edit zsh aliases" })
map('n', '<leader>zz', '<Cmd>e ~/.config/zsh/.zshrc<CR>', { desc = "Edit zshrc" })
map('n', '<leader>zf', '<Cmd>e ~/.config/zsh/.aliases-functions<CR>', { desc = "Edit zsh functions" })
map("n", "}", "}zz", { desc = "Scroll line down centered" })
map("n", "{", "{zz", { desc = "Scroll line up centered" })

-- =====================
-- Editing shortcuts
-- =====================
map({ "n", "v", "x" }, "<C-s>", [[:s/\V]], { desc = "Enter substitute mode" })
map({ "v", "x", "n" }, "<C-y>", '"+y', { desc = "Yank to system clipboard" })

-- =====================
-- File exec
-- =====================
map("n", "<leader>X", function()
	local file = vim.fn.expand("%")
	if vim.fn.getfsize(file) > 0 then
		vim.fn.system({ "chmod", "+x", file })
		print("Made " .. vim.fn.expand("%:t") .. " executable")
	end
end, { desc = "Make current file executable" })

-- =====================
-- Auto commands
-- =====================
vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*.sh",
	callback = function()
		local file = vim.fn.expand("%")
		if vim.fn.getfsize(file) > 0 then
			vim.fn.system({ "chmod", "+x", file })
		end
	end,
})

map("n", "<leader>u", "<Cmd>source %<CR>")
map("n", "<leader>U", "<Cmd>restart<CR>")
map({ "n", "v", "x" }, "<C-s>", [[:s/\V]])
map({ "v", "x", "n" }, "<C-y>", '"+y')

-- Yank full buffer
map("n", "<leader>za", 'ggVG"+y')
-- =====================
-- Spell control (optional)
-- =====================
-- map("n", "<leader>gg", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "Show grammar issues" })
-- map("n", "<leader>ss", "<cmd>set spell!<CR>", { desc = "Toggle spell check" })
-- map("n", "<leader>se", "<cmd>set spelllang=en_us<CR>", { desc = "English spell" })
-- map("n", "<leader>sd", "<cmd>set spelllang=de<CR>", { desc = "German spell" })
-- map("n", "z=", "z=1<CR>", { silent = true, desc = "Accept 1st suggestion" })
--
map("n", "<leader>tv", ":TypstPreview<CR>", { buffer = 0, desc = "Typst Preview" })
