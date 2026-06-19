-- ~/.config/nvim/lua/plugins/oil.lua
require("oil").setup({
  default_file_explorer = true,
  columns = {
	  -- "permissions",
		"size",
    -- "mtime",
    "icon",
  },
  buf_options = {
    buflisted = false,
    bufhidden = "hide",
  },
  win_options = {
    wrap = false,
    signcolumn = "no",
    cursorcolumn = false,
    foldcolumn = "0",
    spell = false,
    list = false,
    conceallevel = 3,
    concealcursor = "nvic",
  },
  delete_to_trash = true,
  skip_confirm_for_simple_edits = true,
  prompt_save_on_select_new_entry = false,
  cleanup_delay_ms = 2000,
  lsp_file_methods = {
    enabled = true,
    timeout_ms = 1000,
    autosave_changes = true,
  },
  constrain_cursor = "editable",
  watch_for_changes = false,
  keymaps = {
    ["g?"] = { "actions.show_help", mode = "n" },
    ["<CR>"] = "actions.select",
    ["<C-s>"] = { "actions.select", opts = { vertical = true } },
    ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
    ["<C-t>"] = { "actions.select", opts = { tab = true } },
    ["<C-p>"] = "actions.preview",
    ["<C-q>"] = { "actions.close", mode = "n" },
  	["<Esc>"]  = { "actions.close", mode = "n" },
    ["<C-l>"] = "actions.refresh",
    ["-"] = { "actions.parent", mode = "n" },
    ["_"] = { "actions.open_cwd", mode = "n" },
    ["`"] = { "actions.cd", mode = "n" },
    ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
    ["gs"] = { "actions.change_sort", mode = "n" },
    ["go"] = "actions.open_external",
    ["gz"] = { "actions.toggle_hidden", mode = "n" },
    ["<C-d>"] = { "actions.toggle_trash", mode = "n" },
["gd"] = { mode = "n", callback = function() vim.cmd("Oil " .. vim.fn.expand("~/Downloads")) end, },
["gw"] = { mode = "n", callback = function() vim.cmd("Oil " .. vim.fn.expand("~/Documents/")) end, },
["gp"] = { mode = "n", callback = function() vim.cmd("Oil " .. vim.fn.expand("~/Pictures/")) end, },
["gv"] = { mode = "n", callback = function() vim.cmd("Oil " .. vim.fn.expand("~/Videos/")) end, },
["gf"] = { mode = "n", callback = function() vim.cmd("Oil " .. vim.fn.expand("~/dotfiles/")) end, },
["g."] = { mode = "n", callback = function() vim.cmd("Oil " .. vim.fn.expand("~/.config/")) end, },
["gl"] = { mode = "n", callback = function() vim.cmd("Oil " .. vim.fn.expand("~/.local/bin/")) end, },
["gh"] = { mode = "n", callback = function() vim.cmd("Oil " .. vim.fn.expand("~")) end }
  },
  use_default_keymaps = true,
  view_options = {
    show_hidden = true,
    natural_order = "fast",
    case_insensitive = true,
    sort = {
      { "type", "asc" },
      { "name", "asc" },
    },
  },
  float = {
    padding = 2,
    max_width = 0.7,
    max_height = 0.6,
    border = "rounded",
    win_options = {
      winblend = 0,
    },
    override = function(conf)
      local ui = vim.api.nvim_list_uis()[1]
      local width = conf.width or math.floor(ui.width * 0.3)
      local height = conf.height or math.floor(ui.height * 0.3)

      conf.width = width
      conf.height = height
      conf.row = math.floor((ui.height - height) / 2)
      conf.col = math.floor((ui.width - width) / 2)

      return conf
    end,
  },
})

