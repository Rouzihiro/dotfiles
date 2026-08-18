local M = {}

local MAX_PREVIEW_LINES = 500
local MAX_PREVIEW_BYTES = 2 * 1024 * 1024 -- 2MB

-- Localize frequently used APIs for speed and clarity.
local api = vim.api
local fn = vim.fn
local bo = vim.bo
local wo = vim.wo
local notify = vim.notify
local log_levels = vim.log.levels
local loop = vim.loop

-- ============================================================================
-- Helpers
-- ============================================================================

local function display_path(path)
	return fn.fnamemodify(path, ":~:.")
end

local function get_filetype(path)
	-- Prefer filetype for a filename/buffer; fallback to shebang detection.
	local filetype = vim.filetype.match({
		filename = path,
	})

	if filetype and filetype ~= "" then
		return filetype
	end

	-- Detect extensionless shell scripts from their shebang.
	local ok, lines = pcall(fn.readfile, path, "", 2)

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
	-- Read only the first line in binary mode and look for NUL.
	local ok, lines = pcall(fn.readfile, path, "b", 1)

	if not ok or not lines or #lines == 0 then
		return false
	end

	return lines[1]:find("\0", 1, true) ~= nil
end

local function file_size_ok(path)
	local stat = loop.fs_stat(path)
	if not stat or not stat.size then
		return true
	end
	return stat.size <= MAX_PREVIEW_BYTES
end

local function can_preview(path)
	if not path or path == "" then
		return false
	end

	if fn.filereadable(path) ~= 1 then
		return false
	end

	if is_binary(path) then
		return false
	end

	if not file_size_ok(path) then
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
	-- map index -> item (avoids collisions from identical display strings)
	local lookup_by_index = {}

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

		return fn.matchfuzzy(source or {}, query)
	end

	-- --------------------------------------------------------------------------
	-- Rebuild results
	-- --------------------------------------------------------------------------

	local function rebuild_items()
		items = get_items()

		display_items = {}
		lookup_by_index = {}

		for idx, item in ipairs(items) do
			local display = display_path(item)
			display_items[#display_items + 1] = display
			lookup_by_index[#display_items] = item
		end
	end

	-- --------------------------------------------------------------------------
	-- Dimensions
	-- --------------------------------------------------------------------------

	local total_width = math.floor(vim.o.columns * 0.80)
	local total_height = math.floor(vim.o.lines * 0.60)

	-- clamp minimal sizes to avoid bad values on tiny terminals
	total_width = math.max(total_width, 40)
	total_height = math.max(total_height, 8)

	local picker_width = math.floor(total_width * 0.45)
	local preview_width = total_width - picker_width - 1

	local row = math.floor((vim.o.lines - total_height) / 2)
	local col = math.floor((vim.o.columns - total_width) / 2)

	-- --------------------------------------------------------------------------
	-- Buffers
	-- --------------------------------------------------------------------------

	search_buf = api.nvim_create_buf(false, true)
	picker_buf = api.nvim_create_buf(false, true)
	preview_buf = api.nvim_create_buf(false, true)

	for _, buf in ipairs({
		search_buf,
		picker_buf,
		preview_buf,
	}) do
		bo[buf].bufhidden = "wipe"
		bo[buf].buftype = "nofile"
		bo[buf].swapfile = false
	end

	bo[picker_buf].modifiable = false
	bo[preview_buf].modifiable = false

	-- --------------------------------------------------------------------------
	-- Windows
	-- --------------------------------------------------------------------------

	search_win = api.nvim_open_win(
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

	picker_win = api.nvim_open_win(
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

	preview_win = api.nvim_open_win(
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

	wo[search_win].number = false
	wo[search_win].relativenumber = false
	wo[search_win].cursorline = false
	wo[search_win].signcolumn = "no"
	wo[search_win].wrap = false

	-- Four spaces of comfortable padding before the search text.
	api.nvim_buf_set_lines(search_buf, 0, -1, false, { "    " })

	-- --------------------------------------------------------------------------
	-- Search input
	-- --------------------------------------------------------------------------

	local SEARCH_PADDING = "    "

	local function get_query()
		local line = api.nvim_buf_get_lines(search_buf, 0, 1, false)[1] or ""
		-- Ignore the cosmetic leading padding.
		return line:sub(#SEARCH_PADDING + 1)
	end

	-- --------------------------------------------------------------------------
	-- Preview helpers
	-- --------------------------------------------------------------------------

	local function set_preview_message(message)
		if not api.nvim_buf_is_valid(preview_buf) then
			return
		end

		bo[preview_buf].modifiable = true

		api.nvim_buf_set_lines(preview_buf, 0, -1, false, { "", "  " .. message })

		bo[preview_buf].modifiable = false
		bo[preview_buf].filetype = ""
	end

	local function preview_buffer_by_bufnr(bufnr)
		if not api.nvim_buf_is_valid(preview_buf) then
			return
		end

		if not api.nvim_buf_is_valid(bufnr) then
			set_preview_message("Buffer not available.")
			return
		end

		local line_count = api.nvim_buf_line_count(bufnr)
		local n = math.min(line_count, MAX_PREVIEW_LINES)

		local ok, lines = pcall(api.nvim_buf_get_lines, bufnr, 0, n, false)
		if not ok or not lines then
			set_preview_message("No preview available.")
			return
		end

		bo[preview_buf].modifiable = true
		api.nvim_buf_set_lines(preview_buf, 0, -1, false, lines)
		bo[preview_buf].modifiable = false

		-- adopt buffer's filetype when available
		bo[preview_buf].filetype = bo[bufnr].filetype or ""
	end

	local function update_preview()
		if closed then
			return
		end

		if not api.nvim_win_is_valid(picker_win) then
			return
		end

		local line = api.nvim_win_get_cursor(picker_win)[1]
		local item = lookup_by_index[line]

		if not item then
			set_preview_message("No file selected.")
			return
		end

		-- If item is a buffer number, preview from buffer.
		if type(item) == "number" then
			preview_buffer_by_bufnr(item)
			return
		end

		-- Otherwise, treat it as a path.
		local path = tostring(item)

		if not can_preview(path) then
			set_preview_message("No text preview available.")
			return
		end

		-- Read file safely.
		local ok, lines = pcall(fn.readfile, path, "", MAX_PREVIEW_LINES)
		if not ok or not lines then
			set_preview_message("Failed to read file.")
			return
		end

		bo[preview_buf].modifiable = true
		api.nvim_buf_set_lines(preview_buf, 0, -1, false, lines)
		bo[preview_buf].modifiable = false

		bo[preview_buf].filetype = get_filetype(path)

		if api.nvim_win_is_valid(preview_win) then
			api.nvim_win_set_cursor(preview_win, { 1, 0 })
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

		bo[picker_buf].modifiable = true

		api.nvim_buf_set_lines(picker_buf, 0, -1, false, display_items)

		bo[picker_buf].modifiable = false

		if #display_items == 0 then
			set_preview_message("No matches.")
			return
		end

		api.nvim_win_set_cursor(picker_win, { 1, 0 })

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
			if api.nvim_win_is_valid(win) then
				api.nvim_win_close(win, true)
			end
		end

		for _, buf in ipairs({
			search_buf,
			picker_buf,
			preview_buf,
		}) do
			if api.nvim_buf_is_valid(buf) then
				api.nvim_buf_delete(buf, { force = true })
			end
		end
	end

	-- --------------------------------------------------------------------------
	-- Focus results / search
	-- --------------------------------------------------------------------------

	local function focus_results()
		searching = false

		if api.nvim_win_is_valid(picker_win) then
			api.nvim_set_current_win(picker_win)
		end

		vim.cmd("stopinsert")
	end

	local function focus_search()
		searching = true

		if not api.nvim_win_is_valid(search_win) then
			return
		end

		api.nvim_set_current_win(search_win)

		local line = api.nvim_buf_get_lines(search_buf, 0, 1, false)[1] or ""

		api.nvim_win_set_cursor(search_win, { 1, #line })

		vim.cmd("startinsert")
	end

	-- --------------------------------------------------------------------------
	-- Open helper
	-- --------------------------------------------------------------------------

	local function open_in(mode, item)
		-- item can be path (string) or a buffer number for the Buffers picker.
		close()

		if not item then
			return
		end

		if type(item) == "number" then
			-- buffers picker gave us a buffer number; focus that buffer appropriately.
			if not api.nvim_buf_is_valid(item) then
				return
			end

			if mode == "edit" then
				api.nvim_set_current_buf(item)
			elseif mode == "vsplit" then
				vim.cmd("vsplit")
				api.nvim_set_current_buf(item)
			elseif mode == "split" then
				vim.cmd("split")
				api.nvim_set_current_buf(item)
			elseif mode == "tab" then
				vim.cmd("tab sbuffer " .. item)
			end

			return
		end

		-- treat item as path
		local path = tostring(item)
		local esc = fn.fnameescape(path)

		if mode == "edit" then
			vim.cmd("edit " .. esc)
		elseif mode == "vsplit" then
			vim.cmd("vsplit " .. esc)
		elseif mode == "split" then
			vim.cmd("split " .. esc)
		elseif mode == "tab" then
			vim.cmd("tabedit " .. esc)
		end
	end

	-- --------------------------------------------------------------------------
	-- Select
	-- --------------------------------------------------------------------------

	local function select(mode)
		-- If we're still in the search field, move focus to results.
		if searching then
			focus_results()
			return
		end

		local line = api.nvim_win_get_cursor(picker_win)[1]
		local item = lookup_by_index[line]

		if not item then
			return
		end

		-- Default Enter should call the provided callback (preserves callers' expectations).
		if not mode or mode == "edit" then
			close()
			callback(item)
			return
		end

		-- split/tab behavior
		open_in(mode, item)
	end

	-- --------------------------------------------------------------------------
	-- Search buffer keymaps
	-- --------------------------------------------------------------------------

	api.nvim_buf_set_keymap(search_buf, "i", "<Esc>", "", { callback = focus_results, noremap = true, silent = true })
	api.nvim_buf_set_keymap(search_buf, "i", "<CR>", "", { callback = function() select("edit") end, noremap = true, silent = true })
	api.nvim_buf_set_keymap(search_buf, "i", "<Down>", "", {
		callback = function()
			focus_results()
			vim.cmd("normal! j")
		end,
		noremap = true,
		silent = true,
	})
	api.nvim_buf_set_keymap(search_buf, "i", "<C-d>", "", {
		callback = function()
			if api.nvim_win_is_valid(preview_win) then
				api.nvim_win_call(preview_win, function() vim.cmd("normal! <C-d>") end)
			end
		end,
		noremap = true,
		silent = true,
	})
	api.nvim_buf_set_keymap(search_buf, "i", "<C-u>", "", {
		callback = function()
			if api.nvim_win_is_valid(preview_win) then
				api.nvim_win_call(preview_win, function() vim.cmd("normal! <C-u>") end)
			end
		end,
		noremap = true,
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
		if searching and api.nvim_win_is_valid(search_win) then
			api.nvim_set_current_win(search_win)
		end
	end

	api.nvim_create_autocmd({ "TextChangedI", "TextChanged" }, {
		buffer = search_buf,
		callback = update_query,
	})

	-- --------------------------------------------------------------------------
	-- Result buffer keymaps
	-- --------------------------------------------------------------------------

	-- Buffer-local normal mappings using keymap.set style with buffer set to picker_buf.
	vim.keymap.set("n", "<Esc>", close, { buffer = picker_buf, silent = true })
	vim.keymap.set("n", "q", close, { buffer = picker_buf, silent = true })
	vim.keymap.set("n", "<CR>", function() select("edit") end, { buffer = picker_buf, silent = true })
	vim.keymap.set("n", "/", focus_search, { buffer = picker_buf, silent = true })

	-- Open in splits/tabs
	vim.keymap.set("n", "v", function() select("vsplit") end, { buffer = picker_buf, silent = true })
	vim.keymap.set("n", "s", function() select("split") end, { buffer = picker_buf, silent = true })
	vim.keymap.set("n", "t", function() select("tab") end, { buffer = picker_buf, silent = true })

	vim.keymap.set("n", "<C-d>", function()
		if api.nvim_win_is_valid(preview_win) then
			api.nvim_win_call(preview_win, function() vim.cmd("normal! <C-d>") end)
		end
	end, { buffer = picker_buf, silent = true })

	vim.keymap.set("n", "<C-u>", function()
		if api.nvim_win_is_valid(preview_win) then
			api.nvim_win_call(preview_win, function() vim.cmd("normal! <C-u>") end)
		end
	end, { buffer = picker_buf, silent = true })

	-- --------------------------------------------------------------------------
	-- Preview updates
	-- --------------------------------------------------------------------------

	api.nvim_create_autocmd("CursorMoved", {
		buffer = picker_buf,
		callback = function() update_preview() end,
	})

	-- --------------------------------------------------------------------------
	-- Initial render + focus
	-- --------------------------------------------------------------------------

	render()

	vim.schedule(function()
		if api.nvim_win_is_valid(search_win) then
			api.nvim_set_current_win(search_win)

			local line = api.nvim_buf_get_lines(search_buf, 0, 1, false)[1] or ""
			api.nvim_win_set_cursor(search_win, { 1, #line })
			vim.cmd("startinsert")
		end
	end)
end

-- ============================================================================
-- Files
-- ============================================================================

function M.files(local_search)
	local ok, native_find = pcall(require, "find")
	if not ok or not native_find then
		notify("finder: 'find' module not available", log_levels.WARN)
		return
	end

	local finder

	if local_search then
		finder = native_find.local_
	else
		finder = native_find.global
	end

	open_picker(
		finder,
		local_search and "Find files" or "Find files globally",
		function(file)
			-- file may be a path (string)
			if type(file) == "string" then
				vim.cmd("edit " .. fn.fnameescape(file))
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
		if fn.filereadable(file) == 1 then
			files[#files + 1] = file
		end
	end

	open_picker(
		files,
		"Recent files",
		function(file)
			if type(file) == "string" then
				vim.cmd("edit " .. fn.fnameescape(file))
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

	for _, buf in ipairs(api.nvim_list_bufs()) do
		if api.nvim_buf_is_loaded(buf) and bo[buf].buflisted then
			local name = api.nvim_buf_get_name(buf)

			if name ~= "" then
				local display = display_path(name)

				files[#files + 1] = display
				lookup[display] = buf
			end
		end
	end

	-- Pass an anonymous callback that uses the *lookup* captured above to resolve buffers.
	open_picker(
		files,
		"Buffers",
		function(display)
			local buf = lookup[display]
			if buf and api.nvim_buf_is_valid(buf) then
				api.nvim_set_current_buf(buf)
			end
		end
	)
end

-- ============================================================================
-- Grep
-- ============================================================================

function M.grep()
	if fn.executable("rg") ~= 1 then
		notify("rg not found (ripgrep). Install ripgrep or use another search method.", log_levels.WARN)
		return
	end

	local text = fn.input("Search: ")

	if text == "" then
		return
	end

	local results = fn.systemlist({
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
		notify("No matches found", log_levels.INFO)
		return
	end

	fn.setqflist({}, " ", {
		title = "rg: " .. text,
		lines = results,
		efm = "%f:%l:%c:%m",
	})

	vim.cmd("copen")
end

return M