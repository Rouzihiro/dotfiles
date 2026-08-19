local M = {}

local MAX_PREVIEW_LINES = 500
-- ============================================================================
-- Helpers
-- ============================================================================

local function display_path(path)
	return vim.fn.fnamemodify(path, ":~:.")
end

local function get_filetype(path)
	local filetype = vim.filetype.match({
		filename = path,
	})

	if filetype then
		return filetype
	end

	-- Detect extensionless shell scripts from their shebang.
	local ok, lines = pcall(vim.fn.readfile, path, "", 2)

	if ok and lines then
		for _, line in ipairs(lines) do
			if line:match("^#!.*[ /]bash") then
				return "sh"
			end

			if line:match("^#!.*[ /]sh") then
				return "sh"
			end
		end
	end

	return ""
end

local function is_binary(path)
	local ok, lines = pcall(vim.fn.readfile, path, "b", 1)

	if not ok or not lines or #lines == 0 then
		return false
	end

	return lines[1]:find("\0", 1, true) ~= nil
end

local function can_preview(path)
	if not path or path == "" then
		return false
	end

	if vim.fn.filereadable(path) ~= 1 then
		return false
	end

	if is_binary(path) then
		return false
	end

	return true
end

-- ============================================================================
-- Picker
-- ============================================================================

local function open_picker(source, prompt, callback)
	local query = ""

	local items = {}
	local display_items = {}
	local lookup = {}

	local search_buf
	local picker_buf
	local preview_buf

	local search_win
	local picker_win
	local preview_win

	local closed = false
	local searching = true

	-- --------------------------------------------------------------------------
	-- Source
	-- --------------------------------------------------------------------------

	local function get_items()
		if type(source) == "function" then
			return source(query) or {}
		end

		if query == "" then
			return source or {}
		end

		return vim.fn.matchfuzzy(source or {}, query)
	end

	-- --------------------------------------------------------------------------
	-- Rebuild results
	-- --------------------------------------------------------------------------

	local function rebuild_items()
		items = get_items()

		display_items = {}
		lookup = {}

		for _, item in ipairs(items) do
			local display = display_path(item)

			display_items[#display_items + 1] = display
			lookup[display] = item
		end
	end

	-- --------------------------------------------------------------------------
	-- Dimensions
	-- --------------------------------------------------------------------------

	local total_width = math.floor(vim.o.columns * 0.80)
	local total_height = math.floor(vim.o.lines * 0.60)

	local picker_width = math.floor(total_width * 0.45)
	local preview_width = total_width - picker_width - 1

	local row = math.floor(
		(vim.o.lines - total_height) / 2
	)

	local col = math.floor(
		(vim.o.columns - total_width) / 2
	)

	-- --------------------------------------------------------------------------
	-- Buffers
	-- --------------------------------------------------------------------------

	search_buf = vim.api.nvim_create_buf(false, true)
	picker_buf = vim.api.nvim_create_buf(false, true)
	preview_buf = vim.api.nvim_create_buf(false, true)

	for _, buf in ipairs({
		search_buf,
		picker_buf,
		preview_buf,
	}) do
		vim.bo[buf].bufhidden = "wipe"
		vim.bo[buf].buftype = "nofile"
		vim.bo[buf].swapfile = false
	end

	vim.bo[picker_buf].modifiable = false
	vim.bo[preview_buf].modifiable = false

	-- --------------------------------------------------------------------------
	-- Windows
	-- --------------------------------------------------------------------------

	search_win = vim.api.nvim_open_win(
		search_buf,
		true,
		{
			relative = "editor",
			width = total_width - 2,
			height = 1,
			row = row,
			col = col + 1,
			style = "minimal",
			border = "rounded",
			title = " Search ",
			title_pos = "left",
		}
	)

	picker_win = vim.api.nvim_open_win(
		picker_buf,
		false,
		{
			relative = "editor",
			width = picker_width,
			height = total_height - 2,
			row = row + 2,
			col = col,
			border = "rounded",
			title = " " .. prompt .. " ",
			title_pos = "center",
		}
	)

	preview_win = vim.api.nvim_open_win(
		preview_buf,
		false,
		{
			relative = "editor",
			width = preview_width,
			height = total_height - 2,
			row = row + 2,
			col = col + picker_width + 1,
			border = "rounded",
			title = " Preview ",
			title_pos = "center",
		}
	)

	-- --------------------------------------------------------------------------
	-- Search window appearance
	-- --------------------------------------------------------------------------

	vim.wo[search_win].number = false
	vim.wo[search_win].relativenumber = false
	vim.wo[search_win].cursorline = false
	vim.wo[search_win].signcolumn = "no"
	vim.wo[search_win].wrap = false

	-- Four spaces of comfortable padding before the search text.
	vim.api.nvim_buf_set_lines(
		search_buf,
		0,
		-1,
		false,
		{ "    " }
	)

	-- --------------------------------------------------------------------------
	-- Search input
	-- --------------------------------------------------------------------------

	local SEARCH_PADDING = "    "

	local function get_query()
		local line = vim.api.nvim_buf_get_lines(
			search_buf,
			0,
			1,
			false
		)[1] or ""

		-- Ignore the cosmetic leading padding.
		return line:sub(#SEARCH_PADDING + 1)
	end

	-- --------------------------------------------------------------------------
	-- Preview
	-- --------------------------------------------------------------------------

	local function set_preview_message(message)
		if not vim.api.nvim_buf_is_valid(preview_buf) then
			return
		end

		vim.bo[preview_buf].modifiable = true

		vim.api.nvim_buf_set_lines(
			preview_buf,
			0,
			-1,
			false,
			{
				"",
				"  " .. message,
			}
		)

		vim.bo[preview_buf].modifiable = false
		vim.bo[preview_buf].filetype = ""
	end

	local function update_preview()
		if closed then
			return
		end

		if not vim.api.nvim_win_is_valid(picker_win) then
			return
		end

		local line = vim.api.nvim_win_get_cursor(
			picker_win
		)[1]

		local display = display_items[line]

		if not display then
			set_preview_message("No file selected.")
			return
		end

		local path = lookup[display]

		if not path then
			set_preview_message("No file selected.")
			return
		end

		if not can_preview(path) then
			set_preview_message("No text preview available.")
			return
		end

		local lines = vim.fn.readfile(
			path,
			"",
			MAX_PREVIEW_LINES
		)

		vim.bo[preview_buf].modifiable = true

		vim.api.nvim_buf_set_lines(
			preview_buf,
			0,
			-1,
			false,
			lines
		)

		vim.bo[preview_buf].modifiable = false

		vim.bo[preview_buf].filetype = get_filetype(path)

		if vim.api.nvim_win_is_valid(preview_win) then
			vim.api.nvim_win_set_cursor(
				preview_win,
				{ 1, 0 }
			)
		end
	end

	-- --------------------------------------------------------------------------
	-- Render
	-- --------------------------------------------------------------------------

	local function render()
		if closed then
			return
		end

		rebuild_items()

		vim.bo[picker_buf].modifiable = true

		vim.api.nvim_buf_set_lines(
			picker_buf,
			0,
			-1,
			false,
			display_items
		)

		vim.bo[picker_buf].modifiable = false

		if #display_items == 0 then
			set_preview_message("No matches.")
			return
		end

		vim.api.nvim_win_set_cursor(
			picker_win,
			{ 1, 0 }
		)

		update_preview()
	end

	-- --------------------------------------------------------------------------
	-- Close
	-- --------------------------------------------------------------------------

	local function close()
		if closed then
			return
		end

		closed = true

		for _, win in ipairs({
			search_win,
			picker_win,
			preview_win,
		}) do
			if vim.api.nvim_win_is_valid(win) then
				vim.api.nvim_win_close(win, true)
			end
		end

		for _, buf in ipairs({
			search_buf,
			picker_buf,
			preview_buf,
		}) do
			if vim.api.nvim_buf_is_valid(buf) then
				vim.api.nvim_buf_delete(
					buf,
					{ force = true }
				)
			end
		end
	end

	-- --------------------------------------------------------------------------
	-- Focus results
	-- --------------------------------------------------------------------------

	local function focus_results()
		searching = false

		if vim.api.nvim_win_is_valid(picker_win) then
			vim.api.nvim_set_current_win(picker_win)
		end

		vim.cmd("stopinsert")
	end

	-- --------------------------------------------------------------------------
	-- Focus search
	-- --------------------------------------------------------------------------

	local function focus_search()
		searching = true

		if not vim.api.nvim_win_is_valid(search_win) then
			return
		end

		vim.api.nvim_set_current_win(search_win)

		local line = vim.api.nvim_buf_get_lines(
			search_buf,
			0,
			1,
			false
		)[1] or ""

		vim.api.nvim_win_set_cursor(
			search_win,
			{ 1, #line }
		)

		vim.cmd("startinsert")
	end

	-- --------------------------------------------------------------------------
	-- Select
	-- --------------------------------------------------------------------------

	local function select()
		if searching then
			focus_results()
			return
		end

		local line = vim.api.nvim_win_get_cursor(
			picker_win
		)[1]

		local display = display_items[line]

		if not display then
			return
		end

		local path = lookup[display]

		close()

		if path then
			callback(path)
		end
	end

	-- --------------------------------------------------------------------------
	-- Open with split/vsplit helper
	-- --------------------------------------------------------------------------

	local function open_with(cmd)
		-- If still focused on search, move focus to results so cursor selection is available.
		if searching then
			focus_results()
		end

		if not vim.api.nvim_win_is_valid(picker_win) then
			return
		end

		local line = vim.api.nvim_win_get_cursor(picker_win)[1]
		local display = display_items[line]
		if not display then
			return
		end

		local path = lookup[display]
		if not path then
			return
		end

		close()

		-- pass the open mode to callback: "split", "vsplit", or nil
		callback(path, cmd)
	end

	-- --------------------------------------------------------------------------
	-- Search buffer keymaps
	-- --------------------------------------------------------------------------

	vim.keymap.set("i", "<Esc>", function()
		focus_results()
	end, {
		buffer = search_buf,
		silent = true,
	})

	vim.keymap.set("i", "<CR>", function()
		select()
	end, {
		buffer = search_buf,
		silent = true,
	})

	vim.keymap.set("i", "<Down>", function()
		focus_results()

		vim.cmd("normal! j")
	end, {
		buffer = search_buf,
		silent = true,
	})

	vim.keymap.set("i", "<C-d>", function()
		if vim.api.nvim_win_is_valid(preview_win) then
			vim.api.nvim_win_call(
				preview_win,
				function()
					vim.cmd("normal! <C-d>")
				end
			)
		end
	end, {
		buffer = search_buf,
		silent = true,
	})

	vim.keymap.set("i", "<C-u>", function()
		if vim.api.nvim_win_is_valid(preview_win) then
			vim.api.nvim_win_call(
				preview_win,
				function()
					vim.cmd("normal! <C-u>")
				end
			)
		end
	end, {
		buffer = search_buf,
		silent = true,
	})

	-- --------------------------------------------------------------------------
	-- Live search
	-- --------------------------------------------------------------------------

	local function update_query()
		if closed then
			return
		end

		local new_query = get_query()

		if new_query == query then
			return
		end

		query = new_query

		render()

		-- Keep focus in the search bar while typing.
		if searching
			and vim.api.nvim_win_is_valid(search_win)
		then
			vim.api.nvim_set_current_win(search_win)
		end
	end

	vim.api.nvim_create_autocmd(
		{ "TextChangedI", "TextChanged" },
		{
			buffer = search_buf,
			callback = update_query,
		}
	)

	-- --------------------------------------------------------------------------
	-- Result buffer keymaps
	-- --------------------------------------------------------------------------

	vim.keymap.set("n", "<Esc>", close, {
		buffer = picker_buf,
		silent = true,
	})

	vim.keymap.set("n", "q", close, {
		buffer = picker_buf,
		silent = true,
	})

	vim.keymap.set("n", "<CR>", select, {
		buffer = picker_buf,
		silent = true,
	})

	vim.keymap.set("n", "/", focus_search, {
		buffer = picker_buf,
		silent = true,
	})

	-- horizontal split
	vim.keymap.set("n", "s", function()
		open_with("split")
	end, {
		buffer = picker_buf,
		silent = true,
	})

	-- vertical split
	vim.keymap.set("n", "v", function()
		open_with("vsplit")
	end, {
		buffer = picker_buf,
		silent = true,
	})

	vim.keymap.set("n", "<C-d>", function()
		if vim.api.nvim_win_is_valid(preview_win) then
			vim.api.nvim_win_call(
				preview_win,
				function()
					vim.cmd("normal! <C-d>")
				end
			)
		end
	end, {
		buffer = picker_buf,
		silent = true,
	})

	vim.keymap.set("n", "<C-u>", function()
		if vim.api.nvim_win_is_valid(preview_win) then
			vim.api.nvim_win_call(
				preview_win,
				function()
					vim.cmd("normal! <C-u>")
				end
			)
		end
	end, {
		buffer = picker_buf,
		silent = true,
	})

	-- --------------------------------------------------------------------------
	-- Preview updates
	-- --------------------------------------------------------------------------

	vim.api.nvim_create_autocmd("CursorMoved", {
		buffer = picker_buf,
		callback = function()
			update_preview()
		end,
	})

	-- --------------------------------------------------------------------------
	-- Initial render + focus
	-- --------------------------------------------------------------------------

	render()

	vim.schedule(function()
		if vim.api.nvim_win_is_valid(search_win) then
			vim.api.nvim_set_current_win(search_win)

			local line = vim.api.nvim_buf_get_lines(
				search_buf,
				0,
				1,
				false
			)[1] or ""

			vim.api.nvim_win_set_cursor(
				search_win,
				{ 1, #line }
			)

			vim.cmd("startinsert")
		end
	end)
end

-- ============================================================================
-- Files
-- ============================================================================

function M.files(local_search)
	local native_find = require("find")

	local finder

	if local_search then
		finder = native_find.local_
	else
		finder = native_find.global
	end

	open_picker(
		finder,
		local_search and "Find files" or "Find files globally",
		function(file, open_mode)
			if open_mode == "split" then
				vim.cmd("split " .. vim.fn.fnameescape(file))
			elseif open_mode == "vsplit" then
				vim.cmd("vsplit " .. vim.fn.fnameescape(file))
			else
				vim.cmd("edit " .. vim.fn.fnameescape(file))
			end
		end
	)
end

-- ============================================================================
-- Recent files
-- ============================================================================

function M.oldfiles()
	local files = {}

	for _, file in ipairs(vim.v.oldfiles) do
		if vim.fn.filereadable(file) == 1 then
			files[#files + 1] = file
		end
	end

	open_picker(
		files,
		"Recent files",
		function(file, open_mode)
			if open_mode == "split" then
				vim.cmd("split " .. vim.fn.fnameescape(file))
			elseif open_mode == "vsplit" then
				vim.cmd("vsplit " .. vim.fn.fnameescape(file))
			else
				vim.cmd("edit " .. vim.fn.fnameescape(file))
			end
		end
	)
end

-- ============================================================================
-- Buffers
-- ============================================================================

function M.buffers()
	local files = {}
	local lookup = {}

	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(buf)
			and vim.bo[buf].buflisted
		then
			local name = vim.api.nvim_buf_get_name(buf)

			if name ~= "" then
				local display = display_path(name)

				files[#files + 1] = display
				lookup[display] = buf
			end
		end
	end

	open_picker(
		files,
		"Buffers",
		function(display, open_mode)
			local buf = lookup[display]

			if not buf or not vim.api.nvim_buf_is_valid(buf) then
				return
			end

			if open_mode == "split" then
				vim.cmd("split")
				vim.api.nvim_set_current_buf(buf)
			elseif open_mode == "vsplit" then
				vim.cmd("vsplit")
				vim.api.nvim_set_current_buf(buf)
			else
				vim.api.nvim_set_current_buf(buf)
			end
		end
	)
end

-- ============================================================================
-- Grep
-- ============================================================================

function M.grep()
	local text = vim.fn.input("Search: ")

	if text == "" then
		return
	end

	local results = vim.fn.systemlist({
		"rg",
		"--vimgrep",
		"--smart-case",
		"--hidden",
		"--glob",
		"!.git",
		"--glob",
		"!node_modules",
		"--glob",
		"!.cache",
		"--glob",
		"!dist",
		"--glob",
		"!build",
		"--",
		text,
		".",
	})

	if #results == 0 then
		vim.notify(
			"No matches found",
			vim.log.levels.INFO
		)
		return
	end

	vim.fn.setqflist({}, " ", {
		title = "rg: " .. text,
		lines = results,
		efm = "%f:%l:%c:%m",
	})

	vim.cmd("copen")
end

return M
