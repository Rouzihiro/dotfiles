vim.g.netrw_liststyle = 3
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
vim.g.netrw_browse_split = 0
vim.g.netrw_altfile = 1

-- Show dotfiles/hidden files by default
vim.g.netrw_hide = 0

-- Reuse the same explorer window
vim.g.netrw_altv = 1

-- Keep cwd synced with browsing location
vim.g.netrw_keepdir = 0

vim.api.nvim_create_autocmd("FileType", {
	pattern = "netrw",

	callback = function()
		vim.keymap.set("n", "%", function()
			local fname = vim.fn.input("Create: ")

			if fname == "" then
				return
			end

			local dir = vim.b.netrw_curdir or vim.fn.getcwd()

			local path = dir .. "/" .. fname

			if vim.fn.filereadable(path) == 1 or vim.fn.isdirectory(path) == 1 then
				vim.notify("Already exists: " .. fname, vim.log.levels.WARN)

				return
			end

			-- Directory creation
			if fname:match("/$") then
				local clean = path:gsub("/+$", "")

				vim.fn.mkdir(clean, "p")

				vim.notify("Created directory: " .. fname, vim.log.levels.INFO)

				-- File creation
			else
				local file = io.open(path, "w")

				if not file then
					vim.notify("Failed creating: " .. fname, vim.log.levels.ERROR)

					return
				end

				file:close()

				vim.notify("Created file: " .. fname, vim.log.levels.INFO)
			end

			-- Refresh netrw and stay inside explorer
			vim.cmd("edit")
		end, {
			buffer = true,
			silent = true,
			noremap = true,
			desc = "Create file or directory",
		})

		-- Optional: easier refresh
		vim.keymap.set("n", "R", "<cmd>edit<CR>", {
			buffer = true,
			silent = true,
			noremap = true,
			desc = "Refresh netrw",
		})
	end,
})
