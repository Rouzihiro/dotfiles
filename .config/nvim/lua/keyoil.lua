local map = vim.keymap.set

vim.api.nvim_create_autocmd("FileType", {
  pattern = "oil",
  callback = function()
    map('n', '<leader>n', function()
      vim.cmd("OilNewFile")
    end, { desc = "Create new file in Oil", buffer = true })
  end,
})

