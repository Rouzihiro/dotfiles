-- Built-in completion configuration

vim.opt.completeopt = {
	"menu",
	"menuone",
	"popup",
	"noinsert",
	"fuzzy",
}

-- Enter accepts the highlighted completion, otherwise behaves normally
vim.keymap.set("i", "<CR>", function()
	return vim.fn.pumvisible() == 1 and "<C-y>" or "<CR>"
end, { expr = true, noremap = true })

-- Custom path completion that includes dotfiles/hidden files
-- (native <C-x><C-f> uses glob(), which silently drops dotfiles; readdir() doesn't)
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
	local prefix = base:match("([^/]*)$") or base
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

-- Trigger path completion automatically after typing "/", and keep it alive
-- (cmp-style) as you keep typing, instead of dying after one selection.
local function open_path_completion()
	vim.schedule(function()
		if vim.fn.mode() == "i" then
			vim.api.nvim_feedkeys(
				vim.api.nvim_replace_termcodes("<C-x><C-u>", true, false, true),
				"n",
				false
			)
		end
	end)
end

vim.api.nvim_create_autocmd("InsertCharPre", {
	callback = function()
		if vim.v.char == "/" then
			vim.b.__path_completing = true
			open_path_completion()
		elseif vim.v.char:match("[%s\"'%(%)]") then
			-- left path-context: space, quote, or paren ends the streak
			vim.b.__path_completing = false
		end
	end,
})

-- Keep re-triggering completion on every keystroke while inside a path,
-- so the menu doesn't die after you pick or narrow one entry.
vim.api.nvim_create_autocmd("TextChangedI", {
	callback = function()
		if vim.b.__path_completing and vim.fn.pumvisible() == 0 then
			open_path_completion()
		end
	end,
})

-- Reset the streak when leaving insert mode or bailing with Esc
vim.api.nvim_create_autocmd("InsertLeave", {
	callback = function()
		vim.b.__path_completing = false
	end,
})
