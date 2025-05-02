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

-- Treesitter
require("nvim-treesitter.configs").setup({
  highlight = {
    enable = true,
    disable = { "latex", "tex", "html" }
  },
  auto_install = true,
  sync_install = false,
  additional_vim_regex_highlighting = false,
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
