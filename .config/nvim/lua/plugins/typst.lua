vim.pack.add({
  { src = "https://github.com/chomosuke/typst-preview.nvim" },
})

require("typst-preview").setup({
  open_cmd = "zathura",  -- or "zathura" if you prefer
  auto_refresh = true,
  show_logs = true,       -- enable logs for debug
})

require("typst-preview").setup()


vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.typ",
  callback = function()
    vim.cmd("TypstPreviewRefresh")
  end,
})

vim.keymap.set("n", "<leader>tp", "<cmd>TypstPreviewToggle<CR>", { desc = "Toggle Typst Preview" })
