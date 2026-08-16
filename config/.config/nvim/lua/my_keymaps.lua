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

map.set("c", "<C-Up>", "<C-p>", {
	desc = "Previous completion",
})

map.set("c", "<C-Down>", "<C-n>", {
	desc = "Next completion",
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

map.set("n", "<C-q>", "<Cmd>bwipeout!<CR>", {
	desc = "Discard changes and close buffer",
	group = "Buffers",
})

-- =====================
-- Files
-- =====================

map.set("n", "<leader>e", function()
	require("explorer").open(vim.fn.expand("%:p:h"))
end, { desc = "Open file explorer" })

map.set("n", "<leader>o", function()
	require("finder").oldfiles()
end, {
	desc = "Recent files",
	group = "Files",
})

local picker = require("finder")

map.set("n", "<leader>ff", function()
        picker.files(true)
end, {
        desc = "Find files locally",
})

map.set("n", "<leader>F", function()
        picker.files(false)
end, {
        desc = "Find files globally",
})

map.set("n", "<leader>fb", function()
        picker.buffers()
end, {
        desc = "Find buffers",
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

map.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "moves lines down in visual selection" })
map.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "moves lines up in visual selection" })


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

map.set("n", "<leader>vk", "<Cmd>e ~/.config/nvim/lua/my_keymaps.lua<CR>", {
	desc = "Edit keymaps.lua",
	group = "Config",
})

map.set("n", "<leader>zc", "<Cmd>e ~/zsh/.aliases<CR>", {
	desc = "Edit zsh aliases",
	group = "Config",
})

map.set("n", "<leader>zz", "<Cmd>e ~/zsh/.zshrc<CR>", {
	desc = "Edit zshrc",
	group = "Config",
})

map.set("n", "<leader>zf", "<Cmd>e ~/zsh/.aliases-functions<CR>", {
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

-- =====================
-- Run current file
-- =====================

local function run_current_file()
	local file = vim.fn.expand("%:p")

	if file == "" then
		vim.notify("No file to run", vim.log.levels.ERROR)
		return
	end

	local filename = vim.fn.expand("%:t")
	local extension = vim.fn.expand("%:e")
	local filetype = vim.bo.filetype
	local dir = vim.fn.expand("%:p:h")

	local commands = {
		python = "python3 " .. vim.fn.shellescape(filename),
		lua = "lua " .. vim.fn.shellescape(filename),
		sh = "bash " .. vim.fn.shellescape(filename),
		zsh = "zsh " .. vim.fn.shellescape(filename),

		javascript = "node " .. vim.fn.shellescape(filename),
		typescript = "tsx " .. vim.fn.shellescape(filename),

		c = "gcc " .. vim.fn.shellescape(filename) .. " -o /tmp/nvim_run && /tmp/nvim_run",

		cpp = "g++ " .. vim.fn.shellescape(filename) .. " -o /tmp/nvim_run && /tmp/nvim_run",

		rust = "cargo run",

		go = "go run " .. vim.fn.shellescape(filename),

		java = "javac " .. vim.fn.shellescape(filename) .. " && java " .. vim.fn.fnamemodify(filename, ":r"),

		typst = "tinymist compile " .. vim.fn.shellescape(filename) .. " --format pdf",
	}

	local cmd = commands[filetype]

	if not cmd then
		vim.notify("No run command for: " .. filetype .. " (." .. extension .. ")", vim.log.levels.WARN)
		return
	end

	-- floating terminal size
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.7)

	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	local buf = vim.api.nvim_create_buf(false, true)

	vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,

		border = "rounded",

		title = " Run: " .. filename .. " ",
		title_pos = "center",
	})

	vim.fn.jobstart("cd " .. vim.fn.shellescape(dir) .. " && " .. cmd, {
		term = true,
		on_exit = function(_, code)
			if code == 0 then
				vim.notify("Finished successfully")
			else
				vim.notify("Exited with code " .. code, vim.log.levels.ERROR)
			end
		end,
	})

	vim.cmd("startinsert")

	-- q closes terminal
	vim.keymap.set("n", "q", "<cmd>close<CR>", {
		buffer = buf,
		silent = true,
		desc = "Close runner",
	})
end

vim.keymap.set("n", "<leader>S", run_current_file, {
	desc = "Run current file in floating terminal",
})

map.set("n", "<leader>tt", function()
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.7)

	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	local buf = vim.api.nvim_create_buf(false, true)

	vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		border = "rounded",
		title = " Terminal ",
		title_pos = "center",
	})

	vim.fn.jobstart(vim.o.shell, {
		term = true,
	})

	vim.cmd("startinsert")

	vim.keymap.set("n", "q", "<cmd>close<CR>", {
		buffer = buf,
		silent = true,
		desc = "Close terminal",
	})
end, {
	desc = "Open floating terminal",
})
