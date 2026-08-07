local map = require("keymaps")

-- =====================
-- General
-- =====================

map.set("n", "<esc>", "<cmd>noh<CR>", {
	desc = "Clear search highlight",
})

map.set({ "n", "v", "x" }, ";", ":", {
	desc = "Swap ; and :",
})

map.set({ "n", "v", "x" }, ":", ";", {
	desc = "Swap : and ;",
})

map.set("n", "n", "nzzzv", {
	desc = "Next search result centered",
})

map.set("n", "N", "Nzzzv", {
	desc = "Previous search result centered",
})

map.set("n", "c", '"_c', {
	desc = "Change without yanking",
})

-- =====================
-- Windows
-- =====================

map.set("n", "<leader>s|", "<C-w>v", {
	desc = "Split window vertically",
	group = "Windows",
})

map.set("n", "<leader>s-", "<C-w>s", {
	desc = "Split window horizontally",
	group = "Windows",
})

map.set("n", "<leader>se", "<C-w>=", {
	desc = "Make splits equal size",
	group = "Windows",
})

map.set("n", "<leader>sx", "<cmd>close<CR>", {
	desc = "Close current split",
	group = "Windows",
})

map.set("n", "<leader>sh", "<Cmd>bot sf #<CR>", {
	desc = "Horizontal split alternate file",
	group = "Windows",
})

map.set("n", "<leader>sv", "<Cmd>vert belowright sf #<CR>", {
	desc = "Vertical split alternate file",
	group = "Windows",
})

-- =====================
-- Buffers
-- =====================
map.set("n", "<leader><Tab>", "<C-w>w", {
	desc = "Cycle windows",
})

map.set("n", "<Tab>", "<cmd>bnext<CR>", {
	desc = "Next buffer",
})

map.set("n", "<S-Tab>", "<C-w>w", {
	desc = "Cycle splits",
})

map.set("n", "<leader>w", "<Cmd>write<CR>", {
	desc = "Save buffer",
	group = "Buffers",
})

map.set("n", "<leader>q", "<Cmd>bd<CR>", {
	desc = "Close buffer",
	group = "Buffers",
})

map.set("n", "<leader>Q", "<Cmd>wqa<CR>", {
	desc = "Write and quit all",
	group = "Buffers",
})

map.set("n", "<C-q>", "<Cmd>bd!<CR>", {
	desc = "Force close buffer",
})

-- =====================
-- Files
-- =====================
map.set("n", "-", "<cmd>Explore<CR>", { desc = "Open parent directory (netrw)" })

-- Optional: a persistent sidebar toggle, closer to nvim-tree/neo-tree muscle memory
map.set("n", "<leader>e", "<cmd>Lexplore<CR>", { desc = "Toggle file explorer sidebar" })

map.set("n", "<leader>o", function()
	require("finder").oldfiles()
end, {
	desc = "Recent files",
	group = "Files",
})

map.set("n", "<leader>ff", function()
	require("finder").files()
end, {
	desc = "Find files",
	group = "Files",
})

map.set("n", "<leader>fg", function()
	require("finder").grep()
end, {
	desc = "Search text",
	group = "Files",
})

map.set("n", "<leader>fa", function()
	print(vim.fn.expand("%:p"))
end, {
	desc = "Show absolute path",
	group = "Files",
})

map.set("n", "<leader>ft", function()
	print(vim.fn.expand("%:t"))
end, {
	desc = "Show filename",
	group = "Files",
})

map.set("n", "<leader>fr", function()
	print(vim.fn.fnamemodify(vim.fn.expand("%"), ":."))
end, {
	desc = "Show relative path",
	group = "Files",
})

map.set("n", "<leader>fy", function()
	local path = vim.fn.fnamemodify(vim.fn.expand("%"), ":.")

	vim.fn.setreg("+", path)
	print("yanked: " .. path)
end, {
	desc = "Yank relative path",
	group = "Files",
})

map.set("n", "<leader>cc", "<cmd>lcd %:p:h<CR>", {
	desc = "Change cwd to file directory",
	group = "Files",
})

map.set("n", "<leader>cd", function()
	local dir = vim.fn.input("Change directory: ", vim.fn.getcwd(), "dir")

	if dir ~= "" then
		vim.cmd("cd " .. dir)
		vim.notify("Changed to: " .. dir)
	end
end, {
	desc = "Interactive cd",
	group = "Files",
})

-- =====================
-- Quickfix
-- =====================

map.set("n", "<leader>ho", "<cmd>copen<CR>", {
	desc = "Open quickfix",
	group = "Quickfix",
})

map.set("n", "<leader>hc", "<cmd>cclose<CR>", {
	desc = "Close quickfix",
	group = "Quickfix",
})

map.set("n", "]h", "<cmd>cnext<CR>", {
	desc = "Next quickfix item",
})

map.set("n", "[h", "<cmd>cprev<CR>", {
	desc = "Previous quickfix item",
})

-- =====================
-- Config
-- =====================

map.set({ "n", "v", "x" }, "<leader>u", "<Cmd>source %<CR>", {
	desc = "Source current file",
	group = "Config",
})

map.set("n", "<leader>U", function()
	vim.cmd("source $MYVIMRC")
	vim.notify("Config reloaded")
end, {
	desc = "Reload config",
	group = "Config",
})

-- =====================
-- Editing
-- =====================

map.set({ "n", "v", "x" }, "<C-s>", [[:s/\V]], {
	desc = "Enter substitute mode",
})

map.set({ "n", "v", "x" }, "<C-y>", '"+y', {
	desc = "Yank system clipboard",
})

map.set({ "n", "v" }, "d", '"_d', {
	desc = "Delete without cutting",
})

map.set({ "n", "v" }, "D", '"_D', {
	desc = "Delete line without cutting",
})

map.set("n", "x", '"_x', {
	desc = "Delete character without cutting",
})

map.set("n", "X", "d$", {
	desc = "Cut to end of line",
})

map.set("n", "<leader>y", "yt#", {
	desc = "Yank until #",
	group = "Editing",
})

map.set("n", "<leader>rs", ":%s/\\s\\+$//e<CR>", {
	desc = "Clean trailing whitespace",
	group = "Editing",
})

map.set("n", "P", "mzA<space><esc>p`z", {
	desc = "Paste to end of line",
})

map.set("n", "A", "mzI<space><esc>P`z", {
	desc = "Paste at start of line",
})

map.set("n", "<leader>za", 'ggVG"+y', {
	desc = "Yank entire buffer",
	group = "Editing",
})

map.set({ "n", "v" }, "<leader>rw", ":%s/<C-r><C-w>//g<Left><Left>", {
	desc = "Replace word",
	group = "Editing",
})

map.set({ "n", "v" }, "<leader>rW", ":%s/<C-r><C-w>//gc<Left><Left><Left>", {
	desc = "Replace word confirm",
	group = "Editing",
})

map.set({ "n", "v" }, "<leader>c", "1z=", {
	desc = "Correct spelling",
	group = "Editing",
})

-- =====================
-- Registers
-- =====================

map.set("n", "<leader>R", "<Cmd>display<CR>", {
	desc = "Show registers",
	group = "Registers",
})

for i = 1, 9 do
	map.set("n", "<leader>p" .. i, '"' .. i .. "p", {
		desc = "Paste register " .. i,
		group = "Registers",
	})

	map.set("n", "<leader>P" .. i, '"' .. i .. "P", {
		desc = "Paste register " .. i .. " before cursor",
		group = "Registers",
	})
end

-- =====================
-- LSP / Diagnostics
-- =====================

map.set("n", "K", vim.lsp.buf.hover, {
	desc = "LSP hover",
})

map.set({ "n", "v", "x" }, "<leader>lf", vim.lsp.buf.format, {
	desc = "Format buffer",
	group = "LSP",
})

map.set("n", "<leader>le", function()
	vim.diagnostic.open_float()
end, {
	desc = "Show error under cursor",
	group = "LSP",
})

map.set("n", "<leader>la", function()
	vim.diagnostic.setqflist()
end, {
	desc = "Show all diagnostics",
	group = "LSP",
})

map.set("n", "]]", function()
	vim.diagnostic.jump({
		count = 1,
	})
end, {
	desc = "Next diagnostic",
})

map.set("n", "[[", function()
	vim.diagnostic.jump({
		count = -1,
	})
end, {
	desc = "Previous diagnostic",
})

-- =====================
-- Tools
-- =====================

map.set("i", "<C-Space>", function()
	vim.lsp.completion.get()
end, {
	desc = "Trigger LSP completion",
	group = "Tools",
})

map.set("n", "<leader>tt", "<Cmd>edit .<CR>", {
	desc = "Open current directory",
	group = "Tools",
})

map.set("n", "<leader>X", function()
	local file = vim.fn.expand("%")

	if vim.fn.getfsize(file) > 0 then
		vim.fn.system({
			"chmod",
			"+x",
			file,
		})

		print("Made " .. vim.fn.expand("%:t") .. " executable")
	end
end, {
	desc = "Make current file executable",
	group = "Tools",
})

-- Automatically chmod shell scripts

vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*.sh",

	callback = function()
		vim.fn.system({
			"chmod",
			"+x",
			vim.fn.expand("%"),
		})
	end,
})

-- =====================
-- Config files
-- =====================

map.set("n", "<leader>vc", "<Cmd>e $MYVIMRC<CR>", {
	desc = "Edit init.lua",
	group = "Config",
})

map.set("n", "<leader>vk", "<Cmd>e ~/.config/nvim_native/lua/keymaps.lua<CR>", {
	desc = "Edit keymaps.lua",
	group = "Config",
})

map.set("n", "<leader>zc", "<Cmd>e ~/.config/zsh/.aliases<CR>", {
	desc = "Edit zsh aliases",
	group = "Config",
})

map.set("n", "<leader>zz", "<Cmd>e ~/.config/zsh/.zshrc<CR>", {
	desc = "Edit zshrc",
	group = "Config",
})

map.set("n", "<leader>zf", "<Cmd>e ~/.config/zsh/.aliases-functions<CR>", {
	desc = "Edit zsh functions",
	group = "Config",
})

-- =====================
-- Movement
-- =====================

map.set("n", "}", "}zz", {
	desc = "Scroll down centered",
})

map.set("n", "{", "{zz", {
	desc = "Scroll up centered",
})

-- =====================
-- Typst
-- =====================

map.set("n", "<leader>tv", "<Cmd>TypstPreview<CR>", {
	desc = "Typst preview",
	group = "Tools",
})

-- =====================
-- Avante AI
-- =====================

map.set({ "n", "v", "x" }, "<leader>aa", "<cmd>AvanteAsk<CR>", {
	desc = "Ask AI",
	group = "Avante",
})

map.set({ "n", "v", "x" }, "<leader>ae", "<cmd>AvanteEdit<CR>", {
	desc = "Edit with AI",
	group = "Avante",
})

map.set("n", "<leader>ar", "<cmd>AvanteRefresh<CR>", {
	desc = "Refresh request",
	group = "Avante",
})

map.set("n", "<leader>ax", "<cmd>AvanteStop<CR>", {
	desc = "Stop request",
	group = "Avante",
})

map.set("n", "<leader>af", "<cmd>AvanteFocus<CR>", {
	desc = "Focus sidebar",
	group = "Avante",
})
