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

-- vim.opt.incsearch = true

-- vim.o.spelllang = "en_us,de"
-- vim.o.spellsuggest = "best,9"

vim.pack.add({
	{ src = "https://github.com/EdenEast/nightfox.nvim" },
	{ src = "https://github.com/chentoast/marks.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/aznhe21/actions-preview.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter",        version = "main" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim",          version = "0.1.8" },
	{ src = "https://github.com/nvim-telescope/telescope-ui-select.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/LinArcX/telescope-env.nvim" },
	{ src = "https://github.com/folke/which-key.nvim" },
  { src = "https://github.com/hrsh7th/nvim-cmp" },
  { src = "https://github.com/hrsh7th/cmp-path" },
  { src = "https://github.com/hrsh7th/cmp-buffer" },
  { src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
  { src = "https://github.com/echasnovski/mini.nvim" },
  { src = 'https://github.com/NvChad/showkeys', opt = false },
})

require "marks".setup {
	builtin_marks = { "<", ">", "^" },
	refresh_interval = 250,
	sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
	excluded_filetypes = {},
	excluded_buftypes = {},
	mappings = {}
}

local default_color = "nightfox"

require("mason").setup()

local telescope = require("telescope")
telescope.setup({
	defaults = {
		preview = { treesitter = false },
		color_devicons = true,
		sorting_strategy = "ascending",
		borderchars = {
			"─", -- top
			"│", -- right
			"─", -- bottom
			"│", -- left
			"┌", -- top-left
			"┐", -- top-right
			"┘", -- bottom-right
			"└", -- bottom-left
		},
		path_displays = { "smart" },
		layout_config = {
			height = 100,
			width = 400,
			prompt_position = "top",
			preview_cutoff = 40,
		}
	}
})
telescope.load_extension("ui-select")

require("actions-preview").setup {
	backend = { "telescope" },
	extensions = { "env" },
	telescope = vim.tbl_extend(
		"force",
		require("telescope.themes").get_dropdown(), {}
	)
}

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

require("keymaps")

require("mini.pick").setup()
require("plugins.oil")

require('nightfox').setup({
  options = {
    transparent = true,
    terminal_colors = true,
    dim_inactive = false,
      }
    })
-- require("everforest").setup({ 
-- 	transparent_background_level = 1,
--  	background = "hard",
-- })
-- vim.cmd("colorscheme kanagawa")
vim.cmd("colorscheme nightfox")
vim.cmd(":hi statusline guibg=NONE")

vim.lsp.enable(
	{
		"lua_ls",
		"tinymist",
		"clangd",
		"bashls",
	}
)

-- Snippets
require("luasnip").setup({ enable_autosnippets = true })
require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/" })
local ls = require("luasnip")
vim.keymap.set("i", "<C-e>", function() ls.expand_or_jump(1) end, { silent = true })

-- Set filetype for typst files
vim.filetype.add({
  extension = {
    typ = "typst",
  },
})

local function pack_clean()
	local active_plugins = {}
	local unused_plugins = {}

	for _, plugin in ipairs(vim.pack.get()) do
		active_plugins[plugin.spec.name] = plugin.active
	end

	for _, plugin in ipairs(vim.pack.get()) do
		if not active_plugins[plugin.spec.name] then
			table.insert(unused_plugins, plugin.spec.name)
		end
	end

	if #unused_plugins == 0 then
		print("No unused plugins.")
		return
	end

	local choice = vim.fn.confirm("Remove unused plugins?", "&Yes\n&No", 2)
	if choice == 1 then
		vim.pack.del(unused_plugins)
	end
end

vim.keymap.set("n", "<leader>pc", pack_clean)

local color_group = vim.api.nvim_create_augroup("colors", { clear = true })


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

-- Lua LS
lspconfig.lua_ls.setup({
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = { globals = { 'vim' } },
      workspace = { library = vim.api.nvim_get_runtime_file("", true) },
      telemetry = { enable = false },
    }
  }
})

-- Clangd for C
lspconfig.clangd.setup({
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=never",
    "--completion-style=detailed",
    "--function-arg-placeholders=false"
  },
  filetypes = { "c", "cpp", "objc", "objcpp" }
})

-- Bash LS for shell scripts
lspconfig.bashls.setup({})

