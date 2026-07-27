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
-- vim.o.cursorline = true
local map = vim.keymap.set
vim.g.mapleader = " "
-- =====================
-- Package management
-- =====================
vim.pack.add({
		{ src = "https://github.com/ibhagwan/fzf-lua" },
    -- { src = "https://github.com/chentoast/marks.nvim" },
    { src = "https://github.com/stevearc/oil.nvim" },
    -- { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    { src = "https://github.com/aznhe21/actions-preview.nvim" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
    { src = "https://github.com/nvim-lua/plenary.nvim" },
--		{ src = "https://github.com/yetone/avante.nvim" },
-- { src = "https://github.com/MunifTanjim/nui.nvim" },
-- { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
-- { src = "https://github.com/hrsh7th/nvim-cmp" },
    { src = "https://github.com/chomosuke/typst-preview.nvim" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/L3MON4D3/LuaSnip" },
    { src = "https://github.com/hrsh7th/nvim-cmp" },
    { src = "https://github.com/hrsh7th/cmp-path" },
    { src = "https://github.com/hrsh7th/cmp-buffer" },
    { src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
    { src = "https://github.com/nvim-mini/mini.clue" },
		{ src = "https://github.com/aohoyd/broot.nvim" },
		{ src = "https://github.com/NvChad/nvim-colorizer.lua" },
		{ src = "https://github.com/stevearc/conform.nvim" },
    { src = "https://github.com/GooseRooster/osc-colors.nvim" },
})

require("typst").setup()
require("typst-cheatsheet")
require("fzf_config")
require("keymaps")
require("plugins.cmp")
require("plugins.oil")
require("plugins.mini-clue")
-- require("plugins.avante")
require("luasnip").setup({ enable_autosnippets = true })
require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/" })

-- require("marks").setup {
--     builtin_marks = { "<", ">", "^" },
--     refresh_interval = 250,
--     sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
-- }

require("broot").setup({})

require("conform").setup({
    formatters_by_ft = {
        python = { "ruff_format" },
        lua = { "stylua" },
    },
    format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
    },
})

-- =====================
-- Colorizer (toml files)
-- =====================
require("colorizer").setup({
    filetypes = { "toml" },
    user_default_options = {
        RGB = true,
        RRGGBB = true,
        RRGGBBAA = true,
        names = false,
        mode = "background",
    },
})

-- =====================
-- Theme and color
-- =====================
-- Reads the live 16-color palette straight from the terminal (OSC 4/10/11),
-- so it just follows whatever kitty is currently rendering via osyx.
-- No named scheme, no reload-on-flip logic needed here anymore.
require("osc-colors").setup({
    capabilities = {
        truecolor = true,
        undercurl = false,
        terminal_colors = true,
    },

    ui = {
        transparent = true,
        dim_inactive = false,
    },

    styles = {
        comments  = { italic = true },
        keywords  = {},
        functions = {},
        variables = {},
        types     = {},
    },

    highlights = {
        integrations = {
            telescope = true,
            notify    = true,
            cmp       = true,
            blink     = true,
            dapui     = true,
            lualine   = true,
            snacks    = true,
        },
        use_lazy_specs = true,
    },

    refresh_on = { "UIEnter", "FocusGained" },
})

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

-- Set path to only your specified directories
vim.opt.path = {
		os.getenv("HOME") .. "/.config/**",
	  os.getenv("HOME") .. "/dotfiles/**",
		os.getenv("HOME") .. "/Downloads/**",
		os.getenv("HOME") .. "/Documents/**",
}

-- Ignore problematic files/folders
vim.opt.wildignore = {
		"*/node_modules/*",
		"*/dist/*",
		"*/target/*",
		"*.git/*",
		"*/__pycache__/*",
		"*.pyc",
		"*.swp",
		"*.log",
}

map("n", "<leader>tr", "<cmd>OscColorsRefresh<cr>", { desc = "Refresh terminal colors" })

_G.reload_theme = function()
    vim.cmd("OscColorsRefresh")
end
