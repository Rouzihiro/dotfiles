-- Built-in completion configuration

vim.opt.completeopt = {
	"menu",
	"menuone",
	"popup",
	"noinsert",
	"fuzzy",
}

vim.keymap.set("i", "<CR>", function()
	if vim.fn.pumvisible() == 1 then
		return vim.api.nvim_replace_termcodes("<C-y>", true, false, true)
	end

	return "<CR>"
end, {
	expr = true,
	noremap = true,
})

-- ==========================
-- Hidden file path completion
-- ==========================

local function path_complete(findstart, base)
	if findstart == 1 then
		local line = vim.fn.getline(".")
		local col = vim.fn.col(".") - 1

		local start = col

		while start > 0 and line:sub(start, start):match("[^%s\"'(]") do
			start = start - 1
		end

		return start
	end

	local dir = base:match("^(.*/)") or ""

	local prefix = base:match("([^/]*)$") or ""

	local search_dir = dir == "" and "." or vim.fn.fnamemodify(dir, ":p")

	local ok, files = pcall(vim.fn.readdir, search_dir)

	if not ok then
		return {}
	end

	local results = {}

	for _, f in ipairs(files) do
		if f:sub(1, #prefix) == prefix then
			local isdir = vim.fn.isdirectory(search_dir .. "/" .. f) == 1

			table.insert(results, {

				word = dir .. f .. (isdir and "/" or ""),

				abbr = f .. (isdir and "/" or ""),

				kind = isdir and "dir" or "file",
			})
		end
	end

	return results
end

_G.__path_complete_hidden = path_complete

vim.opt.completefunc = "v:lua.__path_complete_hidden"

local function open_path_completion()
	vim.schedule(function()
		if vim.fn.mode() == "i" then
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-x><C-u>", true, false, true), "n", false)
		end
	end)
end

vim.api.nvim_create_autocmd("InsertCharPre", {
	callback = function()
		if vim.v.char == "/" then
			vim.b.__path_completing = true

			open_path_completion()
		elseif vim.v.char:match("[%s\"'()%)]") then
			vim.b.__path_completing = false
		end
	end,
})

vim.api.nvim_create_autocmd("TextChangedI", {
	callback = function()
		if vim.b.__path_completing and vim.fn.pumvisible() == 0 then
			open_path_completion()
		end
	end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
	callback = function()
		vim.b.__path_completing = false
	end,
})

-- ==========================
-- Zero plugin snippets
-- ==========================

local function get_word_before_cursor()
	local line = vim.api.nvim_get_current_line()

	local col = vim.api.nvim_win_get_cursor(0)[2]

	return line:sub(1, col):match("(%S+)$")
end

local function find_snippet(trigger)
	for _, snippet in ipairs(vim.g.snippets or {}) do
		if snippet.trigger == trigger then
			return snippet
		end
	end

	return nil
end

local function expand_snippet()
	local trigger = get_word_before_cursor()

	if not trigger then
		return false
	end

	local snippet = find_snippet(trigger)

	if not snippet then
		return false
	end

	vim.schedule(function()
		local row, col = unpack(vim.api.nvim_win_get_cursor(0))

		local line = vim.api.nvim_get_current_line()

		local start = col - #trigger

		local before = line:sub(1, start)

		local after = line:sub(col + 1)

		local body = table.concat(snippet.body, "\n")

		body = body:gsub("%$%d+", "")

		local new_lines = vim.split(before .. body .. after, "\n")

		vim.api.nvim_buf_set_lines(0, row - 1, row, false, new_lines)

		vim.api.nvim_win_set_cursor(0, {
			row,
			#new_lines[#new_lines],
		})
	end)

	return true
end

vim.keymap.set("i", "<Tab>", function()
	if expand_snippet() then
		return ""
	end

	if vim.fn.pumvisible() == 1 then
		return vim.api.nvim_replace_termcodes("<C-y>", true, false, true)
	end

	return vim.api.nvim_replace_termcodes("<Tab>", true, false, true)
end, {
	expr = true,
	noremap = true,
})
