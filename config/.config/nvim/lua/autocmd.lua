-- Highlight selection on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
	callback = function()
		vim.highlight.on_yank({
			timeout = 200,
			visual = true,
		})
	end,
})

-- Restore cursor to file position in previous editing session
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function(args)
		local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
		local line_count = vim.api.nvim_buf_line_count(args.buf)

		if mark[1] > 0 and mark[1] <= line_count then
			vim.api.nvim_win_set_cursor(0, mark)

			vim.schedule(function()
				vim.cmd("normal! zz")
			end)
		end
	end,
})

-- Don't continue comments when pressing o/O or Enter
vim.api.nvim_create_autocmd("BufEnter", {
	group = vim.api.nvim_create_augroup("FormatOptions", { clear = true }),
	pattern = "*",
	callback = function()
		vim.opt_local.formatoptions:remove({ "r", "o" })
	end,
})

-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	command = "%s/\\s\\+$//e",
})

-- Automatically rebalance windows after terminal resize
vim.api.nvim_create_autocmd("VimResized", {
	command = "wincmd =",
})

-- Close temporary/help buffers with q
vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"help",
		"man",
		"lspinfo",
		"checkhealth",
	},
	callback = function(args)
		vim.bo[args.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", {
			buffer = args.buf,
			silent = true,
		})
	end,
})

-- Create missing parent directories when saving
vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function(args)
		if args.match:match("^%w%w+://") then
			return
		end

		local file = vim.loop.fs_realpath(args.match) or args.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})

-- Wrap and spellcheck prose
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("TextSettings", { clear = true }),
	pattern = { "markdown", "text", "gitcommit" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.spell = true
	end,
})

-- =====================
-- Filetypes
-- =====================

local group = vim.api.nvim_create_augroup("FiletypeSettings", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = { "lua", "typst", "json", "yaml", "html", "css" },
	callback = function()
		local o = vim.opt_local
		o.tabstop = 2
		o.shiftwidth = 2
		o.expandtab = true
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = { "python", "c", "cpp", "zig" },
	callback = function()
		local o = vim.opt_local
		o.tabstop = 4
		o.shiftwidth = 4
		o.expandtab = true
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = { "go" },
	callback = function()
		local o = vim.opt_local
		o.tabstop = 4
		o.shiftwidth = 4
		o.expandtab = false
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = { "make" },
	callback = function()
		vim.opt_local.expandtab = false
	end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
	callback = function()
		if vim.bo.filetype ~= "directory" then
			return
		end

		vim.wo.cursorline = true
		vim.wo.number = false
		vim.wo.relativenumber = false
		vim.wo.signcolumn = "no"
		vim.wo.winbar = "%#Directory# %{expand('%:p')}"
	end,
})

vim.api.nvim_create_autocmd("BufLeave", {
  callback = function()
    -- Don't run if we're in a floating window or special buffer
    local win = vim.api.nvim_get_current_win()
    local config = vim.api.nvim_win_get_config(win)

    -- Skip if it's a floating window
    if config and config.relative ~= "" then
      return
    end

    local buf = vim.api.nvim_get_current_buf()
    local name = vim.api.nvim_buf_get_name(buf)
    local buftype = vim.bo[buf].buftype  -- New way

    -- Only delete unnamed normal buffers
    if name == "" and buftype == "" and #vim.api.nvim_list_bufs() > 1 then
      vim.cmd("bdelete! " .. buf)
    end
  end,
})
