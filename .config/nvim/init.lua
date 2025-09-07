-- Basic Neovim options
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

-- vim.o.spelllang = "en_us,de"
-- vim.o.spellsuggest = "best,9"

vim.pack.add({
  { src = "https://github.com/rebelot/kanagawa.nvim" },
	{ src = "https://github.com/neanias/everforest-nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/hrsh7th/nvim-cmp" },
  { src = "https://github.com/hrsh7th/cmp-path" },
  { src = "https://github.com/hrsh7th/cmp-buffer" },
  { src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
  { src = "https://github.com/stevearc/oil.nvim", version = "master", opt = false },
  { src = "https://github.com/echasnovski/mini.pick" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/chomosuke/typst-preview.nvim" },
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = 'https://github.com/NvChad/showkeys', opt = true },
  { src = "https://github.com/L3MON4D3/LuaSnip" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
  { src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim", build = "make" },
})

-- Completion setup
local cmp = require("cmp")
cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
  }),
  sources = {
    { name = 'path' },
    { name = 'buffer' },
    { name = 'nvim_lsp' },
  }
})

-- Load your keymaps (make sure this file exists and is correct)
require("keymaps")

-- Setup Mason (optional)
require("mason").setup()

-- Showkeys setup (optional)
require("showkeys").setup({ position = "top-right" })

-- Mini pick
require("mini.pick").setup()

-- Oil plugin
require("plugins.oil")

-- Treesitter setup
-- require('nvim-treesitter.configs').setup({ highlight = { enable = true } })
--
-- Colorscheme
-- require("kanagawa").setup({ transparent = true })
require("everforest").setup({ 
	transparent_background_level = 1,
 	background = "hard",
})
-- vim.cmd("colorscheme kanagawa")
vim.cmd("colorscheme everforest")
vim.cmd(":hi statusline guibg=NONE")

-- Snippets
require("luasnip").setup({ enable_autosnippets = true })
require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/" })
local ls = require("luasnip")
vim.keymap.set("i", "<C-e>", function() ls.expand_or_jump(1) end, { silent = true })
-- Optional snippet navigation keys (uncomment if you want)
-- vim.keymap.set({ "i", "s" }, "<C-j>", function() ls.jump(1) end, { silent = true })
-- vim.keymap.set({ "i", "s" }, "<C-k>", function() ls.jump(-1) end, { silent = true })

-- Set filetype for typst files
vim.filetype.add({
  extension = {
    typ = "typst",
  },
})

-- LSP config for tinymist and others
local lspconfig = require("lspconfig")

-- tinymist setup
lspconfig.tinymist.setup({
  on_attach = function(client, bufnr)
    local function create_tinymist_command(command_name)
      local cmd_display = command_name:match("tinymist%.export(%w+)")
      return function()
        client:exec_cmd({
          title = "Export " .. cmd_display,
          command = command_name,
          arguments = { vim.api.nvim_buf_get_name(bufnr) },
        }, { bufnr = bufnr })
      end
    end

    local commands = {
      "tinymist.exportSvg",
      "tinymist.exportPng",
      "tinymist.exportPdf",
      "tinymist.exportHtml",
      "tinymist.exportMarkdown",
    }

    for _, command in ipairs(commands) do
      local cmd_name = "Export" .. command:match("tinymist%.export(%w+)")
      vim.api.nvim_buf_create_user_command(bufnr, cmd_name, create_tinymist_command(command), {
        nargs = 0,
        desc = "Export to " .. cmd_name:sub(7),
      })
    end

    -- Keymap for quick PDF export
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>t", ":ExportPdf<CR>", { noremap = true, silent = true })
  end,
  filetypes = { "typst" },
  root_dir = lspconfig.util.root_pattern(".git"),
  settings = {
    formatterMode = "typstyle",
  },
})

-- You can add other LSP setups below, like lua_ls, svelte, emmetls, etc.


