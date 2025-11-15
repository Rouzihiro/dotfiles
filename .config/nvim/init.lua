vim.cmd([[set noswapfile]])
vim.opt.winborder = "rounded"
vim.opt.clipboard = "unnamedplus"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.showtabline = 2
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.cursorcolumn = false
vim.opt.ignorecase = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.number = true
vim.o.showmode = true
vim.o.cursorline = true
local map = vim.keymap.set
vim.g.mapleader = " "
-- =====================
-- Package management
-- =====================
vim.pack.add({
		{ src = "https://github.com/ibhagwan/fzf-lua" },
    { src = "https://github.com/chentoast/marks.nvim" },
    { src = "https://github.com/stevearc/oil.nvim" },
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    { src = "https://github.com/aznhe21/actions-preview.nvim" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/chomosuke/typst-preview.nvim" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/L3MON4D3/LuaSnip" },
    { src = "https://github.com/hrsh7th/nvim-cmp" },
    { src = "https://github.com/hrsh7th/cmp-path" },
    { src = "https://github.com/hrsh7th/cmp-buffer" },
    { src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
    { src = "https://github.com/nvim-mini/mini.clue" },
    -- Themes
    { src = "https://github.com/ellisonleao/gruvbox.nvim" },
    { src = "https://github.com/catppuccin/nvim" },
    { src = "https://github.com/rebelot/kanagawa.nvim" },
    { src = "https://github.com/EdenEast/nightfox.nvim" },
    { src = "https://github.com/folke/tokyonight.nvim" },
  	{ src = "https://github.com/vague2k/vague.nvim" },

})

require("fzf_config")
require("keymaps")
require("plugins.cmp")
require("plugins.oil")
require("plugins.mini-clue")
require("luasnip").setup({ enable_autosnippets = true })
require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/" })

require("marks").setup {
    builtin_marks = { "<", ">", "^" },
    refresh_interval = 250,
    sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
}

-- =====================
-- Theme and color
-- =====================
_G.default_color = require("theme").default_color
local color_group = vim.api.nvim_create_augroup("colors", { clear = true })

vim.api.nvim_create_autocmd("ColorScheme", {
    group = color_group,
    callback = function()
        vim.cmd("colorscheme " .. (_G.default_color or "gruvbox"))
    end,
})
vim.cmd('colorscheme ' .. default_color)

-- =====================
-- Mason + LSP
-- =====================
require("mason").setup()
vim.lsp.enable({
    "lua_ls", "cssls", "svelte", "tinymist", "svelteserver",
    "rust_analyzer", "clangd", "ruff",
    "glsl_analyzer", "haskell-language-server", "hlint",
    "intelephense", "biome", "tailwindcss",
    "ts_ls", "emmet_language_server", "emmet_ls", "solargraph"
})
