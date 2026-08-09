vim.opt.grepprg = "rg --vimgrep --smart-case --hidden --glob '!.git'"
vim.opt.grepformat = "%f:%l:%c:%m"

vim.keymap.set("n", "<leader>g", function()
	vim.ui.input({ prompt = "Grep: " }, function(pattern)
		if not pattern or pattern == "" then
			return
		end

		vim.cmd("silent grep! " .. vim.fn.fnameescape(pattern))
		vim.cmd("copen")
	end)
end, { silent = true })
