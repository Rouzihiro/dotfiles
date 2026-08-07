vim.g.mapleader = " "

require("options")
require("snippets").load()
require("completion")
require("lsp")
require("colorscheme")
require("netrw")
require("statusline")
require("find")
require("grep")
require("autocommands")
require("diagnostics")
require("formatting")

require("keymaps")
require("my_keymaps")

require("keymap_gen").generate()

require("keymap_popup").start()

require("typst").setup()
require("typst-cheatsheet")
