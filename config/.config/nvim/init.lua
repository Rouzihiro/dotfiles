vim.g.mapleader = " "
require("vim._core.ui2").enable({})
require("options")
require("snippets").load()
require("completion")
require("lsp")
require("explorer").setup()
require("explorer_bookmarks")
require("colorscheme")
-- require("netrw")
require("statusline")
require("find")
require("grep")
require("autocmd")
require("diagnostics")
require("formatting")

require("keymaps")
require("my_keymaps")

require("keymap_gen").generate()

require("keymap_popup").start()

require("typst").setup()
require("typst-cheatsheet")

require("splash")
