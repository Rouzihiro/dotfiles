local explorer = require("explorer")

local bookmarks = {
	["gd"] = "~/Downloads",
	["gw"] = "~/Documents/",
	["gp"] = "~/Pictures/",
	["gv"] = "~/Videos/",
	["gf"] = "~/dotfiles/",
	["gc"] = "~/.config/",
	["gn"] = "~/.config/nvim/",
	["gb"] = "~/bin/",
	["gh"] = "~",
}

for lhs, path in pairs(bookmarks) do
	vim.keymap.set("n", lhs, function()
		explorer.open(vim.fn.expand(path))
	end, { desc = "Explorer: " .. path })
end

local function pick_bookmark()
	local names = vim.tbl_keys(bookmarks)
	table.sort(names)
	vim.ui.select(names, {
		prompt = "Explorer bookmark:",
		format_item = function(key)
			return string.format("%-4s → %s", key, bookmarks[key])
		end,
	}, function(choice)
		if choice then
			explorer.open(vim.fn.expand(bookmarks[choice]))
		end
	end)
end

vim.keymap.set("n", "<leader>b", pick_bookmark, { desc = "Explorer: pick bookmark" })

return bookmarks
