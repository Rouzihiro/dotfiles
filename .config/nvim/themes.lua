-- ======================
-- THEMES & UI (KANAGAWA WAVE EDITION)
-- ======================
require('kanagawa').setup({
  theme = "wave",  -- Explicitly use the purple/gold variant
  dimInactive = false,
  globalStatus = true,
  colors = {
    theme = {
      all = {
        ui = {
          bg_gutter = "none"  -- Cleaner gutter appearance
        }
      }
    }
  },
  overrides = function(colors)
    local theme = colors.theme
    return {
      -- Custom spell check highlighting (wave-style)
      SpellBad = { undercurl = true, sp = theme.syn.error },
      SpellCap = { undercurl = true, sp = theme.syn.special1 },  -- Purple
      SpellLocal = { undercurl = true, sp = theme.syn.string },   -- Gold

      -- Enhanced UI elements
      TelescopeBorder = { fg = theme.syn.special1 },  -- Purple borders
      TelescopeTitle = { fg = theme.syn.special1, bold = true },
      IblIndent = { fg = theme.ui.nontext },  -- Subtle indent guides
      IblScope = { fg = theme.syn.special1 }, -- Purple scope highlights
    }
  end,
  integrations = {
    cmp = true,
    telescope = true,
    treesitter = true,
    which_key = true,
    lsp_trouble = true,
  },
})
vim.cmd.colorscheme("kanagawa-wave")

-- ======================
-- STATUS LINE (WAVE STYLE)
-- ======================
require("lualine").setup({
  options = {
    theme = "kanagawa",
    component_separators = "|",
    section_separators = { left = "", right = "" },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "filetype" },
    lualine_c = { "filename" },
    lualine_x = { 
      { 
        "diagnostics", 
        symbols = { error = " ", warn = " ", hint = " ", info = " " },
        colored = true,  -- Uses Kanagawa's error/warning colors
      } 
    },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  extensions = { "nvim-tree" }
})

-- ======================
-- TREESITTER (WAVE-OPTIMIZED)
-- ======================
require("nvim-treesitter.configs").setup({
  highlight = {
    enable = true,
    disable = { "latex", "tex", "html" },
    additional_vim_regex_highlighting = false,
    -- Kanagawa-specific query enhancements
    custom_captures = {
      ["function.call"] = "Function",
      ["parameter.inside"] = "Parameter",
    }
  },
  ensure_installed = { "bash", "lua", "markdown", "python" },
  auto_install = true,
  sync_install = false,
})

-- ======================
-- INDENT GUIDES (WAVE STYLE)
-- ======================
require("ibl").setup({
  indent = {
    char = "│",
    highlight = "IblIndent",  -- Uses our custom highlight
  },
  scope = {
    enabled = true,
    show_start = false,
    show_end = false,
    highlight = "IblScope",  -- Purple scope indicators
    char = "▏",
  },
  exclude = {
    filetypes = { "help", "dashboard", "NvimTree" }
  }
})

-- ======================
-- CUSTOM WAVE HIGHLIGHTS
-- ======================
vim.api.nvim_set_hl(0, "Function", { fg = "#E6C384", italic = true })  -- Gold functions
vim.api.nvim_set_hl(0, "Type", { fg = "#957FB8", bold = true })        -- Purple types
vim.api.nvim_set_hl(0, "@parameter", { fg = "#C0A36E" })               -- Gold parameters