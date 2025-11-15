local fzf = require("fzf-lua")

-- =====================
-- FZF-Lua setup
-- =====================
fzf.setup({
  winopts = {
    height = 0.85,
    width = 0.80,
    row = 0.15,
    col = 0.50,
    border = "rounded",
  },
  fzf_opts = {
    ['--layout'] = 'reverse',
    ['--info'] = 'inline',
  },
  files = {
    prompt = "Files ❯ ",
    cwd_prompt = true,
    git_icons = nil,
  },
  grep = {
    prompt = "Grep ❯ ",
    rg_opts = "--hidden --column --line-number --no-heading --color=always --smart-case --glob '!.git/'",
  },
  buffers = {
    prompt = "Buffers ❯ ",
    sort_lastused = true,
  },
  git = {
    icons = nil,
  },
})

-- =====================
-- Keymaps
-- =====================
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- =====================
-- MINI.CLUE HEADERS
-- =====================
map("n", "<leader>f", function() end, { desc = "Files ▸" })
map("n", "<leader>b", function() end, { desc = "Buffers ▸" })
map("n", "<leader>g", function() end, { desc = "Git ▸" })
map("n", "<leader>l", function() end, { desc = "LSP ▸" })
map("n", "<leader>m", function() end, { desc = "Misc ▸" })

-- =====================
-- FILE PICKERS
-- =====================
map("n", "<leader>ff", function() fzf.files() end, { desc = "Find files (cwd)" })
map("n", "<leader>fa", function() fzf.files({ cwd = vim.loop.cwd() }) end, { desc = "Find files (current dir)" })
map("n", "<leader>fg", function() fzf.live_grep() end, { desc = "Live grep project" })
map("n", "<leader>fw", function() fzf.grep_cword() end, { desc = "Search word under cursor" })
map("n", "<leader>fW", function() fzf.grep_cWORD() end, { desc = "Search WORD under cursor" })
map("n", "<leader>fr", function() fzf.resume() end, { desc = "Resume last FZF picker" })

-- =====================
-- BUFFERS / COMMANDS
-- =====================
map("n", "<leader>fb", function() fzf.buffers() end, { desc = "List open buffers" })
map("n", "<leader>fc", function() fzf.commands() end, { desc = "List commands" })
map("n", "<leader>fh", function() fzf.help_tags() end, { desc = "Search help tags" })
map("n", "<leader>fk", function() fzf.keymaps() end, { desc = "Show keymaps" })

-- =====================
-- GIT
-- =====================
map("n", "<leader>gs", function() fzf.git_status() end, { desc = "Git status" })
map("n", "<leader>gc", function() fzf.git_commits() end, { desc = "Git commits" })
map("n", "<leader>gb", function() fzf.git_branches() end, { desc = "Git branches" })

-- =====================
-- LSP
-- =====================
map("n", "gd", function() fzf.lsp_definitions() end, { desc = "Go to definition" })
map("n", "gr", function() fzf.lsp_references() end, { desc = "Show references" })
map("n", "gi", function() fzf.lsp_implementations() end, { desc = "Show implementations" })
map("n", "<leader>ld", function() fzf.diagnostics_document() end, { desc = "Diagnostics (document)" })
map("n", "<leader>lD", function() fzf.diagnostics_workspace() end, { desc = "Diagnostics (workspace)" })
map("n", "<leader>ls", function() fzf.lsp_document_symbols() end, { desc = "Document symbols" })
map("n", "<leader>lS", function() fzf.lsp_workspace_symbols() end, { desc = "Workspace symbols" })

-- =====================
-- MISC
-- =====================
map("n", "<leader>mm", function() fzf.marks() end, { desc = "Show marks" })
map("n", "<leader>qr", function() fzf.quickfix() end, { desc = "Quickfix list" })
map("n", "<leader>jj", function() fzf.jumps() end, { desc = "Jumps history" })

return fzf
