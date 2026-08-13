local todo_file = vim.fn.expand("~/Documents/ToDo.md")

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 0 and vim.fn.line2byte("$") == -1 and vim.fn.filereadable(todo_file) == 1 then
      -- Read todo content
      local lines = vim.fn.readfile(todo_file)
      if vim.tbl_isempty(lines) then
        lines = { "  No tasks yet!" }
      end

      -- Add headline and spacing
      local content = {
        "",
        "           📋  TODO LIST",
        "",
      }
      for _, line in ipairs(lines) do
        table.insert(content, "  " .. line)
      end

      -- Calculate window size
      local width = 60
      local height = math.min(#content + 2, 25)

      -- Create floating window
      local buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)

      local opts = {
        relative = "editor",
        width = width,
        height = height,
        col = (vim.o.columns - width) / 2,
        row = (vim.o.lines - height) / 2 - 2,
        style = "minimal",
        border = "rounded",
      }

      local win = vim.api.nvim_open_win(buf, true, opts)

      -- 'e' to edit
      vim.keymap.set("n", "e", function()
        vim.api.nvim_win_close(win, true)
        vim.cmd("edit " .. todo_file)
        vim.cmd("normal! zz")
      end, { buffer = buf })

      -- Dismiss keys
      vim.keymap.set("n", "q", function()
        vim.api.nvim_win_close(win, true)
      end, { buffer = buf })

      vim.keymap.set("n", "<Esc>", function()
        vim.api.nvim_win_close(win, true)
      end, { buffer = buf })

      vim.keymap.set("n", "<CR>", function()
        vim.api.nvim_win_close(win, true)
      end, { buffer = buf })
    end
  end,
})
