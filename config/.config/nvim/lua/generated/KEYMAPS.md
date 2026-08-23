# Neovim Keymaps

| Mode | Key | Description | Group |
|---|---|---|---|
| n | `<esc>` | Clear search highlight |  |
| n,v,x | `;` | Swap ; and : |  |
| n,v,x | `:` | Swap : and ; |  |
| n | `n` | Next search result centered |  |
| n | `N` | Previous search result centered |  |
| n | `c` | Change without yanking |  |
| c | `<C-Up>` | Previous completion |  |
| c | `<C-Down>` | Next completion |  |
| n | `<leader>s|` | Split window vertically | Windows |
| n | `<leader>s-` | Split window horizontally | Windows |
| n | `<leader>se` | Make splits equal size | Windows |
| n | `<leader>sx` | Close current split | Windows |
| n | `<leader>sh` | Horizontal split alternate file | Windows |
| n | `<leader>sv` | Vertical split alternate file | Windows |
| n | `<leader><Tab>` | Cycle windows |  |
| n | `<Tab>` | Next buffer |  |
| n | `<S-Tab>` | Cycle splits |  |
| n | `<leader>w` | Save buffer | Buffers |
| n | `<leader>q` | Close buffer | Buffers |
| n | `<leader>Q` | Write and quit all | Buffers |
| n | `<C-q>` | Discard changes and close buffer | Buffers |
| n | `<leader>e` | Open file explorer |  |
| n | `<leader>o` | Recent files | Files |
| n | `<leader>ff` | Find files locally | Files |
| n | `<leader>F` | Find files globally | Files |
| n | `<leader>fb` | Find buffers | Files |
| n | `<leader>fg` | Search text | Files |
| n | `<leader>fa` | Show absolute path | Files |
| n | `<leader>ft` | Show filename | Files |
| n | `<leader>fr` | Show relative path | Files |
| n | `<leader>fy` | Yank relative path | Files |
| n | `<leader>cc` | Change cwd to file directory | Files |
| n | `<leader>cd` | Interactive cd | Files |
| n | `<leader>ho` | Open quickfix | Quickfix |
| n | `<leader>hc` | Close quickfix | Quickfix |
| n | `]h` | Next quickfix item |  |
| n | `[h` | Previous quickfix item |  |
| n | `<leader>u` | Hard restart Nvim (no session) | Config |
| n,v,x | `<C-s>` | Enter substitute mode |  |
| n,v | `d` | Delete without cutting |  |
| n,v | `D` | Delete line without cutting |  |
| n | `x` | Delete character without cutting |  |
| n | `X` | Cut to end of line |  |
| n | `<leader>y` | Yank until # | Editing |
| n | `<leader>rs` | Clean trailing whitespace | Editing |
| n | `P` | Paste to end of line |  |
| n | `A` | Paste at start of line |  |
| n | `<leader>za` | Yank entire buffer | Editing |
| n,v | `<leader>rw` | Replace word | Editing |
| n,v | `<leader>rW` | Replace word confirm | Editing |
| n,v | `<leader>c` | Correct spelling | Editing |
| v | `J` | moves lines down in visual selection |  |
| v | `K` | moves lines up in visual selection |  |
| n | `<leader>R` | Show registers | Registers |
| n | `<leader>p1` | Paste register 1 | Registers |
| n | `<leader>P1` | Paste register 1 before cursor | Registers |
| n | `<leader>p2` | Paste register 2 | Registers |
| n | `<leader>P2` | Paste register 2 before cursor | Registers |
| n | `<leader>p3` | Paste register 3 | Registers |
| n | `<leader>P3` | Paste register 3 before cursor | Registers |
| n | `<leader>p4` | Paste register 4 | Registers |
| n | `<leader>P4` | Paste register 4 before cursor | Registers |
| n | `<leader>p5` | Paste register 5 | Registers |
| n | `<leader>P5` | Paste register 5 before cursor | Registers |
| n | `<leader>p6` | Paste register 6 | Registers |
| n | `<leader>P6` | Paste register 6 before cursor | Registers |
| n | `<leader>p7` | Paste register 7 | Registers |
| n | `<leader>P7` | Paste register 7 before cursor | Registers |
| n | `<leader>p8` | Paste register 8 | Registers |
| n | `<leader>P8` | Paste register 8 before cursor | Registers |
| n | `<leader>p9` | Paste register 9 | Registers |
| n | `<leader>P9` | Paste register 9 before cursor | Registers |
| n | `K` | LSP hover |  |
| n,v,x | `<leader>lf` | Format buffer | LSP |
| n | `<leader>le` | Show error under cursor | LSP |
| n | `<leader>la` | Show all diagnostics | LSP |
| n | `]]` | Next diagnostic |  |
| n | `[[` | Previous diagnostic |  |
| i | `<C-Space>` | Trigger LSP completion | Tools |
| n | `<leader>X` | Make current file executable | Tools |
| n | `<leader>vc` | Edit init.lua | Config |
| n | `<leader>vk` | Edit keymaps.lua | Config |
| n | `<leader>zc` | Edit zsh aliases | Config |
| n | `<leader>zz` | Edit zshrc | Config |
| n | `<leader>zf` | Edit zsh functions | Config |
| n | `}` | Scroll down centered |  |
| n | `{` | Scroll up centered |  |
| n | `<leader>tv` | Typst preview | Tools |
| n,v,x | `<leader>aa` | Ask AI | Avante |
| n,v,x | `<leader>ae` | Edit with AI | Avante |
| n | `<leader>ar` | Refresh request | Avante |
| n | `<leader>ax` | Stop request | Avante |
| n | `<leader>af` | Focus sidebar | Avante |
| n | `<leader>tt` | Open floating terminal |  |
| n | `<leader>fu` | undo tree |  |
| n | `<leader>fd` | diff tool |  |
| n | `<leader>fh` | buffer to html | Tools |
