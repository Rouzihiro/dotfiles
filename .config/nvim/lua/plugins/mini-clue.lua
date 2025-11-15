
-- ========================================
-- 🧭 mini.clue - Keymap Discovery Helper
-- ========================================
-- A lightweight alternative to which-key.nvim
-- Shows available keybindings as you type.

local miniclue = require("mini.clue")

miniclue.setup({
 	delay = 1,
  -- Key prefixes that trigger the popup
  triggers = {
    -- Leader mappings
    { mode = "n", keys = "<Leader>" },
    { mode = "x", keys = "<Leader>" },

    -- Built-in completion
    { mode = "i", keys = "<C-x>" },

    -- Motions / commands
    { mode = "n", keys = "g" },
    { mode = "x", keys = "g" },

    -- Marks
    { mode = "n", keys = "'" },
    { mode = "n", keys = "`" },
    { mode = "x", keys = "'" },
    { mode = "x", keys = "`" },

    -- Registers
    { mode = "n", keys = '"' },
    { mode = "x", keys = '"' },
    { mode = "i", keys = "<C-r>" },
    { mode = "c", keys = "<C-r>" },

    -- Windows
    { mode = "n", keys = "<C-w>" },

    -- Fold / z commands
    { mode = "n", keys = "z" },
    { mode = "x", keys = "z" },
  },

  -- Built-in clue generators
  clues = {
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
  },
})
