-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

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
vim.o.cmdheight = 0
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
vim.o.hlsearch = true
vim.o.incsearch = true

vim.o.completeopt = "menuone,noinsert,noselect,popup"

-- vim.o.updatetime = 300
-- vim.o.timeoutlen = 500
-- vim.o.ttimeoutlen = 50
vim.o.autoread = true

vim.o.scrolloff = 8
vim.o.sidescrolloff = 8

vim.o.autochdir = false
vim.o.backspace = "indent,eol,start"

vim.opt.iskeyword:append("-")
vim.opt.path:append("**")
vim.opt.diffopt:append("linematch:60")

vim.o.splitbelow = true
vim.o.splitright = true

vim.o.wildmenu = true
vim.o.wildmode = "longest:full,full"

if vim.loader then
	vim.loader.enable()
end
