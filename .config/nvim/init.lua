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
vim.o.tabstop = 4
vim.o.shiftwidth = 2
vim.o.termguicolors = true
vim.o.clipboard = "unnamedplus"
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true
vim.o.swapfile = false

-- Spell check settings
vim.o.spell = false
vim.o.spelllang = "en_us,de"
vim.o.spellsuggest = "best,9"

-- ======================
-- PLUGIN MANAGER (LAZY.NVIM)
-- ======================
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

require("lazy").setup({
  -- Colorscheme
  { "catppuccin/nvim", name = "catppuccin" },

  -- UI Components
  { "nvim-lualine/lualine.nvim" },
  { "nvim-tree/nvim-web-devicons" },
  { "nvim-tree/nvim-tree.lua" },

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
    ft = { "markdown", "text" },
  },
  {
    "nvimtools/none-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- Tools
  { "nvim-telescope/telescope.nvim" },
  { "nvim-treesitter/nvim-treesitter" },
  { "lukas-reineke/indent-blankline.nvim", main = "ibl" },
  { "folke/which-key.nvim" },
  { "j-hui/fidget.nvim" },

  -- Optional
  { "iamcco/markdown-preview.nvim" },
	{ 'vifm/vifm.vim' },
	{
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup()
    end,
},
})

-- ======================
-- NVIM-TREE CONFIGURATION
-- ======================
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    width = 30,
    side = "left",
  },
  renderer = {
    group_empty = true,
    icons = {
      glyphs = {
        folder = {
          arrow_closed = "▶",
          arrow_open = "▼",
        },
      },
    },
  },
  filters = {
    dotfiles = false,
  },
  actions = {
    open_file = {
      quit_on_open = true,
    },
  },
})

-- Load config files with absolute paths
local function load_config(name)
  local path = vim.fn.stdpath('config') .. '/' .. name .. '.lua'
  if vim.fn.filereadable(path) == 1 then
    dofile(path)
  else
    vim.notify('Config file not found: ' .. path, vim.log.levels.ERROR)
  end
end

-- Load configuration files
load_config('themes')
load_config('keymaps')
load_config('lsp')
