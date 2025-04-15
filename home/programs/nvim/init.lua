-- ======================
-- CORE SETTINGS
-- ======================
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

-- Essential editor settings
vim.o.number = true
vim.o.relativenumber = true
vim.o.smartindent = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.termguicolors = true
vim.o.clipboard = "unnamedplus"
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true
vim.o.swapfile = false
vim.loader.enable()

-- Set custom parser directory to writable location
local parser_install_dir = vim.fn.stdpath("data") .. "/treesitter-parsers"
vim.opt.runtimepath:append(parser_install_dir)
vim.fn.mkdir(parser_install_dir, "p")
vim.g.nvim_treesitter_parser_install_dir = parser_install_dir

-- ======================
-- THEMES & UI
-- ======================
require("catppuccin").setup({
	flavour = "mocha",
	integrations = {
		cmp = true,
		telescope = true,
		treesitter = true,
		which_key = true,
		notify = true,
	},
})
vim.cmd.colorscheme("catppuccin")

-- Status line
require("lualine").setup({
	options = {
		theme = "catppuccin",
		component_separators = "|",
		section_separators = { left = "", right = "" },
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "filetype" },
		lualine_c = { "filename" },
		lualine_x = { "diagnostics" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
})

-- ======================
-- KEYBINDINGS
-- ======================

-- Better bracket navigation with centering
vim.keymap.set("n", "}", "}zz")
vim.keymap.set("n", "{", "{zz")

-- Save and exit mappings
vim.keymap.set("n", "<leader>s", ":w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<C-s>", "ZZ", { desc = "Save & exit" })
vim.keymap.set("n", "<C-x>", "ZQ", { desc = "Exit without saving" })

-- Register management
vim.keymap.set({ "n", "v" }, "<leader>yy", '"ay', { desc = "Yank into reg: a" })
vim.keymap.set({ "n", "v" }, "<leader>yb", '"by', { desc = "Yank into reg: b" })
vim.keymap.set({ "n", "v" }, "<leader>pp", '"ap', { desc = "Paste from reg: a" })
vim.keymap.set({ "n", "v" }, "<leader>pb", '"bp', { desc = "Paste from reg: b" })
vim.keymap.set({ "n", "v" }, "<leader>yx", '"Ay', { desc = "Append to register a" })
vim.keymap.set({ "n", "v" }, "<leader>yb", '"By', { desc = "Append to register b" })

-- Clipboard operations
vim.keymap.set({ "n", "v" }, "<leader>yc", '"+y', { desc = "Yank to clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>pc", '"+p', { desc = "Paste from clipboard" })
vim.keymap.set("n", "<leader>ya", 'ggVG"+y', { desc = "Yank entire buffer" })

-- Search/replace
vim.keymap.set({ "n", "v" }, "<leader>rw", ":%s/<C-r><C-w>//g<Left><Left>", { desc = "Replace word under cursor" })

-- Formatting
vim.keymap.set("n", "<leader>al", "<cmd>lua vim.lsp.buf.format()<CR>", { desc = "Format with Alejandra" })

-- File explorer (lf)
vim.g.lf_map_keys = 0
vim.keymap.set("n", "<leader>t", ":Lf<CR>")

-- Terminal
vim.keymap.set("n", "<leader>th", ":terminal<CR>", { desc = "Open terminal" })

-- Essential editing
vim.keymap.set("n", "<leader>s", ":w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<esc>", "<cmd>noh<CR>")

-- ======================
-- LSP & COMPLETION
-- ======================
local lspcfg = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

lspcfg.nixd.setup({
  capabilities = capabilities,
  settings = {
    nixd = {
      formatting = { command = { "alejandra" } },
    },
  },
})


-- Setup completion
local cmp = require("cmp")
cmp.setup({
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "buffer" },
		{ name = "path" },
	}),
	mapping = cmp.mapping.preset.insert({
		["<C-Space>"] = cmp.mapping.complete(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
	}),
})

-- ======================
-- LATEX (VimTeX)
-- ======================
vim.g.tex_flavor = "latex"
vim.g.vimtex_view_method = "zathura"
vim.g.vimtex_compiler_method = "latexmk"

-- VimTeX keybindings
vim.keymap.set("n", "<leader>ll", "<cmd>VimtexCompile<CR>", { desc = "Compile LaTeX" })
vim.keymap.set("n", "<leader>lv", "<cmd>VimtexView<CR>", { desc = "View PDF" })
vim.keymap.set("n", "<leader>lc", "<cmd>VimtexClean<CR>", { desc = "Clean aux files" })

-- Telescope configuration
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Telescope recent files" })
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

-- Load web devicons
require("nvim-web-devicons").get_icons()

-- ======================
-- MARKDOWN PREVIEW
-- ======================
require("render-markdown").setup({
	enabled = true,
	file_types = { "markdown" },
	heading = {
		enabled = true,
		icons = { "󰲡 ", "󰲣 ", "󰲥 " }, -- Pretty heading icons
	},
})

-- ======================
-- UTILITIES
-- ======================
-- Which-key (shows keybindings)
require("which-key").setup({})

-- Notifications
require("notify").setup({
	stages = "fade",
	timeout = 3000,
})

-- Treesitter (syntax highlighting)
require("nvim-treesitter.configs").setup({
  highlight = {
    enable = true,
    disable = { "html" }
  },
  -- Disable auto-install since we're using Nix-installed parsers
  auto_install = false,
  -- Ensure parsers are available (will use Nix-installed ones)
  ensure_installed = { "nix", "markdown", "latex", "bash" },
  -- Point to our custom parser directory
  parser_install_dir = parser_install_dir
})
