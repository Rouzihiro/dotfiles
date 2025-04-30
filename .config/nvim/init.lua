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

-- Spell check settings
vim.o.spell = false  -- Disabled by default
vim.o.spelllang = "en_us,de"
vim.o.spellsuggest = "best,9"

-- Fedora-specific: Enable lazy.nvim instead of vim.loader
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ======================
-- PLUGINS
-- ======================
require("lazy").setup({
  -- Colorscheme
  { "catppuccin/nvim", name = "catppuccin" },

  -- UI Components
  { "nvim-lualine/lualine.nvim" },
  { "nvim-tree/nvim-web-devicons" },

  -- LSP & Completion
  { "neovim/nvim-lspconfig" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },

  -- Writing Tools
  {
    "vigoux/ltex-ls.nvim",
    ft = { "markdown", "tex", "text" },
    config = function()
      require("ltex-ls").setup({
        language = "en-US,de-DE",
        dictionary = {
          ["en-US"] = { "Neovim", "LSP", "Fedora" },
          ["de-DE"] = { "GitHub", "Backend", "Frontend" }
        }
      })
    end
  },
 {
  "nvimtools/none-ls.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        null_ls.builtins.diagnostics.vale.with({
          extra_args = { "--config=" .. vim.fn.expand("~/.vale.ini") },
        }),
      },
    })
  end,
},

  -- Tools
  { "nvim-telescope/telescope.nvim" },
  { "nvim-treesitter/nvim-treesitter" },
  { "lukas-reineke/indent-blankline.nvim", main = "ibl" },
  { "folke/which-key.nvim" },
  { "j-hui/fidget.nvim" },

  -- Optional
  { "lervag/vimtex" },               -- LaTeX support
  { "iamcco/markdown-preview.nvim" }, -- Markdown preview
})

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
    lsp_trouble = true,
  },
})
vim.cmd.colorscheme("catppuccin")

-- Spell check highlighting
vim.cmd([[
  highlight SpellBad   gui=undercurl guisp=#ff5555
  highlight SpellCap   gui=undercurl guisp=#8be9fd
  highlight SpellLocal gui=undercurl guisp=#50fa7b
]])

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
-- Navigation
vim.keymap.set("n", "}", "}zz")
vim.keymap.set("n", "{", "{zz")

-- File operations
vim.keymap.set("n", "<leader>s", ":w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<C-s>", "ZZ", { desc = "Save & exit" })
vim.keymap.set("n", "<C-x>", "ZQ", { desc = "Exit without saving" })

-- Registers
vim.keymap.set({ "n", "v" }, "<leader>yy", '"ay', { desc = "Yank into reg: a" })
vim.keymap.set({ "n", "v" }, "<leader>yb", '"by', { desc = "Yank into reg: b" })
vim.keymap.set({ "n", "v" }, "<leader>pp", '"ap', { desc = "Paste from reg: a" })
vim.keymap.set({ "n", "v" }, "<leader>pb", '"bp', { desc = "Paste from reg: b" })

-- Clipboard
vim.keymap.set({ "n", "v" }, "<leader>yc", '"+y', { desc = "Yank to clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>pc", '"+p', { desc = "Paste from clipboard" })
vim.keymap.set("n", "<leader>za", 'ggVG"+y', { desc = "Yank entire buffer" })

-- Search/replace
vim.keymap.set({ "n", "v" }, "<leader>rw", ":%s/<C-r><C-w>//g<Left><Left>", { desc = "Replace word under cursor" })

-- Formatting
vim.keymap.set("n", "<leader>al", "<cmd>lua vim.lsp.buf.format()<CR>", { desc = "Format with LSP" })

-- Spell control
vim.keymap.set("n", "<leader>ss", "<cmd>set spell!<CR>", { desc = "Toggle spell check" })
vim.keymap.set("n", "<leader>se", "<cmd>set spelllang=en_us<CR>", { desc = "English spell" })
vim.keymap.set("n", "<leader>sd", "<cmd>set spelllang=de<CR>", { desc = "German spell" })
vim.keymap.set("n", "z=", "z=1<CR>", { silent = true, desc = "Accept 1st suggestion" })

-- Diagnostics
vim.keymap.set("n", "<leader>gg", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "Show grammar issues" })

-- File explorer
vim.g.lf_map_keys = 0
vim.keymap.set("n", "<leader>t", ":Lf<CR>")

-- Clear highlights
vim.keymap.set("n", "<esc>", "<cmd>noh<CR>")

-- ======================
-- LSP & COMPLETION
-- ======================
local lspcfg = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Mason setup
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "bashls", "lua_ls", "ltex" }
})

-- LSP configurations
lspcfg.lua_ls.setup({ capabilities = capabilities })
lspcfg.bashls.setup({ capabilities = capabilities })
lspcfg.ltex.setup({
  capabilities = capabilities,
  settings = {
    ltex = {
      language = "en-US,de-DE",
      diagnosticSeverity = "information"
    }
  }
})

-- Completion
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

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- ======================
-- LATEX (VimTeX)
-- ======================
vim.g.tex_flavor = "latex"
vim.g.vimtex_view_method = "zathura"
vim.g.vimtex_compiler_method = "latexmk"

vim.keymap.set("n", "<leader>ll", "<cmd>VimtexCompile<CR>", { desc = "Compile LaTeX" })
vim.keymap.set("n", "<leader>lv", "<cmd>VimtexView<CR>", { desc = "View PDF" })
vim.keymap.set("n", "<leader>lc", "<cmd>VimtexClean<CR>", { desc = "Clean aux files" })

-- ======================
-- TELESCOPE
-- ======================
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Recent files" })
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })

-- ======================
-- UTILITIES
-- ======================
-- Which-key
require("which-key").setup({})

-- Treesitter
require("nvim-treesitter.configs").setup({
  highlight = {
    enable = true,
    disable = { "html" }
  },
  auto_install = true,
  ensure_installed = { "bash", "lua", "markdown", "python" }
})

-- Indent guides
require("ibl").setup({
  indent = {
    char = "│",
  },
  scope = {
    enabled = true,
    show_start = false,
    show_end = false,
  },
})

