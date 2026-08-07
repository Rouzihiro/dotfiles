local M = {}

local snippet_dir = vim.fn.stdpath("config") .. "/snippets"

function M.load()
	local snippets = {}

	local files = vim.fn.glob(snippet_dir .. "/*.lua", true, true)

	for _, file in ipairs(files) do
		local ok, data = pcall(dofile, file)

		if ok and type(data) == "table" then
			for _, snippet in ipairs(data) do
				table.insert(snippets, snippet)
			end
		end
	end

	vim.g.snippets = snippets
end

return M
