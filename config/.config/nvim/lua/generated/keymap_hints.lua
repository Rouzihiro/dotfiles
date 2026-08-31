return {
  [":"] = {
    _desc = "Swap : and ;"
  },
  [";"] = {
    _desc = "Swap ; and :"
  },
  ["<C-Down>"] = {
    _desc = "Next completion"
  },
  ["<C-Space>"] = {
    _desc = "Trigger LSP completion",
    _group = "Tools"
  },
  ["<C-Up>"] = {
    _desc = "Previous completion"
  },
  ["<C-q>"] = {
    _desc = "Discard changes and close buffer",
    _group = "Buffers"
  },
  ["<C-s>"] = {
    _desc = "Enter substitute mode"
  },
  ["<S-Tab>"] = {
    _desc = "Cycle splits"
  },
  ["<Tab>"] = {
    _desc = "Next buffer"
  },
  ["<esc>"] = {
    _desc = "Clear search highlight"
  },
  ["<leader>"] = {
    ["<Tab>"] = {
      _desc = "Cycle windows"
    },
    G = {
      _desc = "git diff against HEAD"
    },
    P = {
      ["1"] = {
        _desc = "Paste register 1 before cursor",
        _group = "Registers"
      },
      ["2"] = {
        _desc = "Paste register 2 before cursor",
        _group = "Registers"
      },
      ["3"] = {
        _desc = "Paste register 3 before cursor",
        _group = "Registers"
      },
      ["4"] = {
        _desc = "Paste register 4 before cursor",
        _group = "Registers"
      },
      ["5"] = {
        _desc = "Paste register 5 before cursor",
        _group = "Registers"
      },
      ["6"] = {
        _desc = "Paste register 6 before cursor",
        _group = "Registers"
      },
      ["7"] = {
        _desc = "Paste register 7 before cursor",
        _group = "Registers"
      },
      ["8"] = {
        _desc = "Paste register 8 before cursor",
        _group = "Registers"
      },
      ["9"] = {
        _desc = "Paste register 9 before cursor",
        _group = "Registers"
      },
      _group = "Registers"
    },
    Q = {
      _desc = "Write and quit all",
      _group = "Buffers"
    },
    R = {
      _desc = "Show registers",
      _group = "Registers"
    },
    X = {
      _desc = "Make current file executable",
      _group = "Tools"
    },
    _group = "Windows",
    a = {
      _group = "Avante",
      a = {
        _desc = "Ask AI",
        _group = "Avante"
      },
      e = {
        _desc = "Edit with AI",
        _group = "Avante"
      },
      f = {
        _desc = "Focus sidebar",
        _group = "Avante"
      },
      r = {
        _desc = "Refresh request",
        _group = "Avante"
      },
      x = {
        _desc = "Stop request",
        _group = "Avante"
      }
    },
    c = {
      _desc = "Correct spelling",
      _group = "Editing",
      c = {
        _desc = "Change cwd to file directory",
        _group = "Files"
      },
      d = {
        _desc = "Interactive cd",
        _group = "Files"
      }
    },
    e = {
      _desc = "Open file explorer"
    },
    f = {
      _group = "Files",
      a = {
        _desc = "Show absolute path",
        _group = "Files"
      },
      b = {
        _desc = "Find buffers",
        _group = "Files"
      },
      d = {
        _desc = "diff tool"
      },
      f = {
        _desc = "Find files locally",
        _group = "Files"
      },
      g = {
        _desc = "Search text",
        _group = "Files"
      },
      h = {
        _desc = "buffer to html",
        _group = "Tools"
      },
      r = {
        _desc = "Show relative path",
        _group = "Files"
      },
      t = {
        _desc = "Show filename",
        _group = "Files"
      },
      u = {
        _desc = "undo tree"
      },
      y = {
        _desc = "Yank relative path",
        _group = "Files"
      }
    },
    h = {
      _group = "Quickfix",
      c = {
        _desc = "Close quickfix",
        _group = "Quickfix"
      },
      o = {
        _desc = "Open quickfix",
        _group = "Quickfix"
      }
    },
    l = {
      _group = "LSP",
      a = {
        _desc = "Show all diagnostics",
        _group = "LSP"
      },
      e = {
        _desc = "Show error under cursor",
        _group = "LSP"
      },
      f = {
        _desc = "Format buffer",
        _group = "LSP"
      }
    },
    o = {
      _desc = "Recent files",
      _group = "Files"
    },
    p = {
      ["1"] = {
        _desc = "Paste register 1",
        _group = "Registers"
      },
      ["2"] = {
        _desc = "Paste register 2",
        _group = "Registers"
      },
      ["3"] = {
        _desc = "Paste register 3",
        _group = "Registers"
      },
      ["4"] = {
        _desc = "Paste register 4",
        _group = "Registers"
      },
      ["5"] = {
        _desc = "Paste register 5",
        _group = "Registers"
      },
      ["6"] = {
        _desc = "Paste register 6",
        _group = "Registers"
      },
      ["7"] = {
        _desc = "Paste register 7",
        _group = "Registers"
      },
      ["8"] = {
        _desc = "Paste register 8",
        _group = "Registers"
      },
      ["9"] = {
        _desc = "Paste register 9",
        _group = "Registers"
      },
      _group = "Registers"
    },
    q = {
      _desc = "Close buffer",
      _group = "Buffers"
    },
    r = {
      W = {
        _desc = "Replace word confirm",
        _group = "Editing"
      },
      _group = "Editing",
      s = {
        _desc = "Clean trailing whitespace",
        _group = "Editing"
      },
      w = {
        _desc = "Replace word",
        _group = "Editing"
      }
    },
    s = {
      ["-"] = {
        _desc = "Split window horizontally",
        _group = "Windows"
      },
      _group = "Windows",
      e = {
        _desc = "Make splits equal size",
        _group = "Windows"
      },
      h = {
        _desc = "Horizontal split alternate file",
        _group = "Windows"
      },
      v = {
        _desc = "Vertical split alternate file",
        _group = "Windows"
      },
      x = {
        _desc = "Close current split",
        _group = "Windows"
      },
      ["|"] = {
        _desc = "Split window vertically",
        _group = "Windows"
      }
    },
    t = {
      _group = "Tools",
      t = {
        _desc = "Open floating terminal"
      },
      v = {
        _desc = "Typst preview",
        _group = "Tools"
      }
    },
    u = {
      _desc = "Hard restart Nvim (no session)",
      _group = "Config"
    },
    v = {
      _group = "Config",
      c = {
        _desc = "Edit init.lua",
        _group = "Config"
      },
      k = {
        _desc = "Edit keymaps.lua",
        _group = "Config"
      }
    },
    w = {
      _desc = "Save buffer",
      _group = "Buffers"
    },
    y = {
      _desc = "Yank until #",
      _group = "Editing"
    },
    z = {
      _group = "Editing",
      a = {
        _desc = "Yank entire buffer",
        _group = "Editing"
      },
      c = {
        _desc = "Edit zsh aliases",
        _group = "Config"
      },
      f = {
        _desc = "Edit zsh functions",
        _group = "Config"
      },
      z = {
        _desc = "Edit zshrc",
        _group = "Config"
      }
    }
  },
  A = {
    _desc = "Paste at start of line"
  },
  D = {
    _desc = "Delete line without cutting"
  },
  J = {
    _desc = "moves lines down in visual selection"
  },
  K = {
    _desc = "LSP hover"
  },
  N = {
    _desc = "Previous search result centered"
  },
  P = {
    _desc = "Paste to end of line"
  },
  X = {
    _desc = "Cut to end of line"
  },
  ["["] = {
    ["["] = {
      _desc = "Previous diagnostic"
    },
    h = {
      _desc = "Previous quickfix item"
    }
  },
  ["]"] = {
    ["]"] = {
      _desc = "Next diagnostic"
    },
    h = {
      _desc = "Next quickfix item"
    }
  },
  c = {
    _desc = "Change without yanking"
  },
  d = {
    _desc = "Delete without cutting"
  },
  n = {
    _desc = "Next search result centered"
  },
  x = {
    _desc = "Delete character without cutting"
  },
  ["{"] = {
    _desc = "Scroll up centered"
  },
  ["}"] = {
    _desc = "Scroll down centered"
  }
}