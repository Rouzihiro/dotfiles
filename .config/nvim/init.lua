-- ======================
-- CORE SETTINGS (KANAGAWA STYLE)
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
  -- Colorscheme (Kanagawa replaces Catppuccin)
  { "rebelot/kanagawa.nvim" },  -- The Great Wave theme

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
-- KANAGAWA THEME CONFIGURATION
-- ======================
require('kanagawa').setup({
  undercurl = true,
  commentStyle = { italic = true },
  functionStyle = {},
  keywordStyle = { italic = true},
  statementStyle = { bold = true },
  typeStyle = {},
  variablebuiltinStyle = { italic = true},
  specialReturn = true,
  specialException = true,
  transparent = false,
  dimInactive = false,
  colors = {
    theme = {
      all = {
        ui = {
          bg_gutter = "none"
        }
      }
    }
  },
  overrides = function(colors)
    local theme = colors.theme
    return {
      -- Wave-inspired highlights
      NormalFloat = { bg = "none" },
      FloatBorder = { bg = "none", fg = theme.syn.special1 },
      TelescopeTitle = { fg = theme.syn.special1, bold = true },
      TelescopeBorder = { fg = theme.syn.special1 },
      TelescopePromptBorder = { fg = theme.syn.special1 },
    }
  end,
})

-- Set the colorscheme (wave variant for the classic look)
vim.cmd.colorscheme("kanagawa-wave")

-- ======================
-- NVIM-TREE CONFIGURATION (KANAGAWA STYLE)
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
      show = {
        git = true,
        folder = true,
        file = true,
        folder_arrow = true,
      },
    },
    highlight_git = true,
    indent_markers = {
      enable = true,
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

-- ======================
-- TELESCOPE (GREP) CONFIGURATION (WAVE STYLE)
-- ======================
require('telescope').setup({
  defaults = {
    vimgrep_arguments = {
      'rg', -- Ripgrep
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--hidden',
    },
    mappings = {
      i = {
        ['<C-q>'] = require('telescope.actions').send_to_qflist,
      },
    },
    border = true,
    borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
    color_devicons = true,
    prompt_prefix = "🔭 ",
    selection_caret = " ",
    entry_prefix = "  ",
    initial_mode = "insert",
  },
  pickers = {
    live_grep = {
      additional_args = function(opts)
        return { "--hidden", "--glob=!**/.git/*" } -- Search hidden files but ignore .git
      end,
    },
  },
})

-- ======================
-- LUALINE CONFIGURATION (WAVE STYLE)
-- ======================
require('lualine').setup({
  options = {
    theme = 'kanagawa',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
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
load_config('keymaps')
load_config('lsp')

-- ======================
-- KANAGAWA-INSPIRED CUSTOM HIGHLIGHTS
-- ======================
vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#957FB8", bg = "NONE" })  -- Wave purple
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
vim.api.nvim_set_hl(0, "Pmenu", { bg = "#1F1F28" })  -- Dark background
vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#2A2A37", fg = "#C0A36E" })  -- Gold selection