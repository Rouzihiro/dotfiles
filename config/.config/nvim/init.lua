vim.g.mapleader = " "
vim.cmd.packadd("nvim.undotree")
vim.cmd.packadd("nvim.difftool")
vim.cmd.packadd("nvim.tohtml")
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

require("keymap_popup").setup()

require("typst").setup()
require("typst-cheatsheet")

require("splash")
