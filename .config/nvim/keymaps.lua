-- ======================
-- KEYBINDINGS
-- ======================
-- Navigation
vim.keymap.set("n", "}", "}zz")
vim.keymap.set("n", "{", "{zz")

-- File operations
vim.keymap.set("n", "<leader>s", ":w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<C-s>", "ZZ", { desc = "Save & exit" })
vim.keymap.set("n", "<C-x>", "ZQ", { desc = "Exit without saving" })

-- Registers
vim.keymap.set({ "n", "v" }, "<leader>yy", '"ay', { desc = "Yank into reg: a" })
vim.keymap.set({ "n", "v" }, "<leader>yb", '"by', { desc = "Yank into reg: b" })
vim.keymap.set({ "n", "v" }, "<leader>pp", '"ap', { desc = "Paste from reg: a" })
vim.keymap.set({ "n", "v" }, "<leader>pb", '"bp', { desc = "Paste from reg: b" })

-- Clipboard
vim.keymap.set({ "n", "v" }, "<leader>yc", '"+y', { desc = "Yank to clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>pc", '"+p', { desc = "Paste from clipboard" })
vim.keymap.set("n", "<leader>za", 'ggVG"+y', { desc = "Yank entire buffer" })

-- Search/replace
vim.keymap.set({ "n", "v" }, "<leader>rw", ":%s/<C-r><C-w>//g<Left><Left>", { desc = "Replace word under cursor" })

-- Formatting
vim.keymap.set("n", "<leader>al", "<cmd>lua vim.lsp.buf.format()<CR>", { desc = "Format with LSP" })

-- Spell control
vim.keymap.set("n", "<leader>ss", "<cmd>set spell!<CR>", { desc = "Toggle spell check" })
vim.keymap.set("n", "<leader>se", "<cmd>set spelllang=en_us<CR>", { desc = "English spell" })
vim.keymap.set("n", "<leader>sd", "<cmd>set spelllang=de<CR>", { desc = "German spell" })
vim.keymap.set("n", "z=", "z=1<CR>", { silent = true, desc = "Accept 1st suggestion" })

-- Diagnostics
vim.keymap.set("n", "<leader>gg", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "Show grammar issues" })

-- File explorer
vim.g.lf_map_keys = 0
vim.keymap.set("n", "<leader>t", ":Lf<CR>")

-- Clear highlights
vim.keymap.set("n", "<esc>", "<cmd>noh<CR>")

-- Telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Recent files" })
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })

-- Which-key
require("which-key").setup({})
