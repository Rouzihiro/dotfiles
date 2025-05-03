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

-- delete not cut
vim.keymap.set ({"n", "v"}, "d", "\"_d")
vim.keymap.set ({"n", "v"}, "D", "\"_D")

vim.keymap.set ({"n", "v"}, "X", "dd")

vim.keymap.set({"n"}, "<space>a", "mzA<space><esc>p`z", { desc = "paste to the end of line" })

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

-- ======================
-- FILE EXPLORER (Vifm)
-- ======================
vim.keymap.set("n", "<leader>fm", "<cmd>Vifm<CR>", { desc = "Open Vifm file manager" })
vim.keymap.set("n", "<leader>fM", "<cmd>Vifm .<CR>", { desc = "Open Vifm in current directory" })

-- Clear highlights
vim.keymap.set("n", "<esc>", "<cmd>noh<CR>")

-- Telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Recent files" })
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })


-- ======================
-- DIAGNOSTICS NAVIGATION
-- ======================

-- Open all diagnostics in quickfix list
vim.keymap.set('n', '<leader>tl', function() vim.diagnostic.setqflist() end,
  { desc = 'Diagnostics to quickfix' })

-- Open floating diagnostic under cursor
vim.keymap.set('n', '<leader>tc', function() vim.diagnostic.open_float() end,
  { desc = 'Line diagnostic' })


-- ======================
-- TELESCOPE DIAGNOSTICS
-- ======================

-- Project-wide diagnostics
vim.keymap.set('n', '<leader>td', '<cmd>Telescope diagnostics<CR>',
  { desc = 'Find diagnostics' })

-- Current buffer diagnostics  
vim.keymap.set('n', '<leader>tD', function()
  require('telescope.builtin').diagnostics({ bufnr = 0 })
end, { desc = 'Find buffer diagnostics' })

-- Interactive grep diagnostics
vim.keymap.set('n', '<leader>tg', function()
  require('telescope.builtin').diagnostics({
    prompt_title = 'Grep Diagnostics',
    grep = true
  })
end, { desc = 'Grep diagnostics' })

-- ======================
-- DIAGNOSTICS TOGGLE
-- ======================
vim.keymap.set('n', '<leader>tx', function()
  local current = not vim.diagnostic.is_enabled()
  vim.diagnostic.enable(current)
  print('Diagnostics ' .. (current and 'enabled' or 'disabled'))
end, { desc = 'Toggle diagnostics' })


-- Which-key
require("which-key").setup({})

