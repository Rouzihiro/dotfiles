local M = {}

local function picker(items, prompt, callback)
	local query = ""

	local function filter()
		local filtered = {}

		for _, item in ipairs(items) do
			if query == "" or item:lower():find(query:lower(), 1, true) then
				table.insert(filtered, item)
			end
		end

		return filtered
	end

	local buf = vim.api.nvim_create_buf(false, true)

	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = math.floor(vim.o.columns * 0.7),
		height = math.floor(vim.o.lines * 0.5),
		row = math.floor(vim.o.lines * 0.25),
		col = math.floor(vim.o.columns * 0.15),
		border = "rounded",
		title = prompt,
		title_pos = "center",
	})

	local function render()
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, filter())
	end

	render()

	vim.keymap.set("n", "<Esc>", function()
		vim.api.nvim_win_close(win, true)
	end, {
		buffer = buf,
	})

	vim.keymap.set("n", "<CR>", function()
		local line = vim.api.nvim_get_current_line()

		vim.api.nvim_win_close(win, true)

		callback(line)
	end, {
		buffer = buf,
	})

	vim.keymap.set("n", "/", function()
		vim.ui.input({
			prompt = "Search: ",
			default = query,
		}, function(input)
			query = input or ""

			render()
		end)
	end, {
		buffer = buf,
	})
end

function M.oldfiles()
	picker(vim.v.oldfiles, "Recent files", function(file)
		vim.cmd("edit " .. vim.fn.fnameescape(file))
	end)
end

function M.files()
	local files = vim.fn.systemlist("find . -type f")

	picker(files, "Files", function(file)
		vim.cmd("edit " .. vim.fn.fnameescape(file))
	end)
end

function M.grep()
	local text = vim.fn.input("Search: ")

	if text == "" then
		return
	end

	vim.cmd("vimgrep /" .. text .. "/gj **/*")

	vim.cmd("copen")
end

return M
