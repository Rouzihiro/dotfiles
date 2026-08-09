vim.o.swapfile = false
vim.o.undofile = true
vim.o.autoread = true

vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.smartindent = true

vim.o.clipboard = "unnamedplus"

vim.o.winborder = "rounded"
vim.o.laststatus = 3
vim.o.cmdheight = 1
vim.o.showtabline = 2
vim.o.showmode = false
vim.o.signcolumn = "yes"
vim.o.number = true
vim.o.relativenumber = true
-- vim.o.cursorline = true

vim.o.termguicolors = true
vim.o.wrap = false
vim.o.cursorcolumn = false

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true

vim.o.scrolloff = 8
vim.o.sidescrolloff = 8

-- vim.o.timeoutlen = 300
-- vim.o.updatetime = 250

if vim.loader then
	vim.loader.enable()
end
