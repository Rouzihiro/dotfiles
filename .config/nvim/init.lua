vim.opt.winborder = "rounded"
vim.opt.clipboard = "unnamedplus"
vim.opt.tabstop = 2
vim.opt.cursorcolumn = false
vim.opt.ignorecase = true
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.swapfile = false
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.incsearch = true
vim.opt.signcolumn = "yes"

vim.o.spelllang = "en_us,de"
vim.o.spellsuggest = "best,9"

vim.pack.add({
	{ src = "https://github.com/rebelot/kanagawa.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/hrsh7th/nvim-cmp" },
	{ src = "https://github.com/hrsh7th/cmp-path" },
--	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim", version = "master", opt = false },
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = 'https://github.com/NvChad/showkeys',                opt = true },
})

local cmp = require("cmp")
cmp.setup({
	mapping = cmp.mapping.preset.insert({
		['<CR>'] = cmp.mapping.confirm({ select = true }),
		['<Tab>'] = cmp.mapping.select_next_item(),
		['<S-Tab>'] = cmp.mapping.select_prev_item(),
	}),
	sources = {
		{ name = 'path' },
	}
})

require("keymaps")
require "mason".setup()
require "showkeys".setup({ position = "top-right" })
require "mini.pick".setup()
require "oil".setup()

local lspconfig = require("lspconfig")
local tinymist_config = require("lsp.tinymist")
lspconfig.tinymist.setup(tinymist_config)

vim.lsp.enable({ "lua_ls", "svelte", "tinymist", "emmetls" })

-- colors
require "kanagawa".setup({ transparent = true })
vim.cmd("colorscheme kanagawa")
vim.cmd(":hi statusline guibg=NONE")
