-- ======================
-- KEYBINDINGS
-- ======================

-- Navigation
vim.keymap.set("n", "}", "}zz")
vim.keymap.set("n", "{", "{zz")

-- Vertical split (split right)
vim.keymap.set('n', '<leader>v', ':vsplit<CR>', { desc = 'Vertical split' })

-- Horizontal split (split below)
vim.keymap.set('n', '<leader>h', ':split<CR>', { desc = 'Horizontal split' })

-- Quick navigation between splits
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to left split' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to lower split' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to upper split' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to right split' })

-- Arrow keys (alternative to Ctrl+hjkl)
vim.keymap.set('n', '<C-Left>',  '<C-w>h', { desc = 'Move to left split' })
vim.keymap.set('n', '<C-Down>',  '<C-w>j', { desc = 'Move to lower split' })
vim.keymap.set('n', '<C-Up>',    '<C-w>k', { desc = 'Move to upper split' })
vim.keymap.set('n', '<C-Right>', '<C-w>l', { desc = 'Move to right split' })

-- Resize splits more easily
vim.keymap.set('n', '<leader>>', ':vertical resize +5<CR>', { desc = 'Increase split width' })
vim.keymap.set('n', '<leader><', ':vertical resize -5<CR>', { desc = 'Decrease split width' })
vim.keymap.set('n', '<leader>+', ':resize +5<CR>', { desc = 'Increase split height' })
vim.keymap.set('n', '<leader>-', ':resize -5<CR>', { desc = 'Decrease split height' })


-- Better Buffer Management
-- Close current buffer and switch to previous (like tabs in other editors)
vim.keymap.set('n', '<leader>cc', ':bp<bar>bd#<CR>', { desc = 'Close buffer (keep window)' })

-- Force-close current buffer (discard changes)
vim.keymap.set('n', '<leader>cx', ':bd!<CR>', { desc = 'Force close buffer (no save)' })

-- Close current split (but keep buffer)
vim.keymap.set('n', '<leader>cw', '<C-w>c', { desc = 'Close split window' })

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
vim.api.nvim_set_keymap('n', '<leader>r"', 'ysiw"', { noremap = true, silent = true })

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
vim.keymap.set("n", "<leader>fH", builtin.help_tags, { desc = "Help tags" })

vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '[F]ind by [G]rep (search content)' })
vim.keymap.set('n', '<leader>fw', function()
  builtin.grep_string({ search = vim.fn.expand('<cword>') })
end, { desc = '[F]ind current [W]ord' })
vim.keymap.set('n', '<leader>fd', function()
  builtin.live_grep({ search_dirs = { vim.fn.input('Directory: ') } })
end, { desc = '[F]ind in [D]irectory' })

-- Open file in vertical split
vim.keymap.set('n', '<leader>fv', ':vsplit<CR>:Telescope find_files<CR>', { desc = 'Find file (vertical split)' })
-- Open file in horizontal split
vim.keymap.set('n', '<leader>fh', ':split<CR>:Telescope find_files<CR>', { desc = 'Find file (horizontal split)' })

-- Enhanced Nvim-tree Keymaps
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'Toggle Explorer' })
vim.keymap.set('n', '<leader>E', ':NvimTreeFindFile<CR>', { desc = 'Reveal Current File' })

-- Smart Focus Control (fixed version)
vim.keymap.set('n', '<leader>o', function()
  local nvim_tree = require('nvim-tree.api')
  if nvim_tree.tree.is_visible() then
    nvim_tree.tree.focus()  -- Focus tree if visible
  else
    nvim_tree.tree.find_file()  -- Reveal and focus if hidden
  end
  -- Return focus to document after delay
  vim.defer_fn(function()
    vim.cmd('wincmd p')  -- Return to previous window
  end, 200)
end, { desc = 'Smart Explorer Focus' })


-- Terminal
-- Make Esc exit terminal insert mode (just like normal Vim)
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Bonus: Toggle terminal quickly
vim.keymap.set('n', '<leader>tt', ':term<CR>i', { desc = 'Open [T]erminal (insert mode)' })

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

