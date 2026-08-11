local pms = vim.api.nvim_get_hl(0, { name = "PmenuSel", link = false })
local dir = vim.api.nvim_get_hl(0, { name = "Directory", link = false })
local vis = vim.api.nvim_get_hl(0, { name = "Visual", link = false })

vim.api.nvim_set_hl(0, "StlMode", {
	fg = pms.fg,
	bg = vis.bg,
})

vim.api.nvim_set_hl(0, "StlGit", {
	fg = dir.fg,
	bg = pms.bg,
})

local modes = {
	n = "NORMAL",
	i = "INSERT",
	v = "VISUAL",
	V = "V-LINE",
	["\22"] = "V-BLOCK",
	c = "COMMAND",
	t = "TERMINAL",
	R = "REPLACE",
	r = "REPLACE",
	s = "SELECT",
	S = "S-LINE",
	["\19"] = "S-BLOCK",
}

local diagnostic_labels = {
	" ",
	" ",
	" ",
	" ",
}

local diagnostic_highlights = {
	"DiagnosticError",
	"DiagnosticWarn",
	"DiagnosticInfo",
	"DiagnosticHint",
}

local function get_diagnostics()
	local counts = vim.diagnostic.count(0) or {}
	local result = {}

	for i = 1, 4 do
		if counts[i] and counts[i] > 0 then
			result[#result + 1] = "%#" .. diagnostic_highlights[i] .. "#" .. diagnostic_labels[i] .. counts[i] .. "%*"
		end
	end

	if #result == 0 then
		return ""
	end

	return table.concat(result, " ") .. " "
end

local function get_lsp()
	local clients = vim.lsp.get_clients({
		bufnr = 0,
	})

	if #clients == 0 then
		return ""
	end

	return " " .. clients[1].name
end

local function get_search()
	local ok, result = pcall(vim.fn.searchcount, {
		recompute = true,
		maxcount = 999,
	})

	if not ok or result.total == 0 then
		return ""
	end

	return "/" .. result.current .. "/" .. result.total
end

local function get_modified()
	if vim.bo.modified then
		return "[+]"
	end

	return ""
end

local function get_readonly()
	if vim.bo.readonly then
		return ""
	end

	return ""
end

local function get_recording()
	local reg = vim.fn.reg_recording()

	if reg ~= "" then
		return "REC @" .. reg
	end

	return ""
end

local function update_git_info()
	local root = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null"):gsub("%s+$", "")

	if root ~= "" then
		vim.b.git_branch = vim.fn.system("git branch --show-current 2>/dev/null"):gsub("%s+$", "")

		local full_path = vim.fn.expand("%:p")

		if full_path ~= "" then
			vim.b.rel_path = full_path:sub(#root + 2)
		else
			vim.b.rel_path = ""
		end
	else
		vim.b.git_branch = nil
		vim.b.rel_path = vim.fn.expand("%:p:~")
	end
end

local function active_statusline()
	local mode = modes[vim.fn.mode()] or vim.fn.mode():upper()

	local branch = ""

	if vim.b.git_branch and vim.b.git_branch ~= "" then
		branch = "%#StlGit# " .. vim.b.git_branch .. " %*"
	end

	local path = vim.b.rel_path or "%f"

	local right = table.concat({
		get_diagnostics(),
		get_modified(),
		get_readonly(),
		get_recording(),
		get_search(),
		get_lsp(),
		vim.bo.filetype,
		"%l:%c",
	}, " ")

	return table.concat({
		"%#StlMode# ",
		mode,
		" %*",
		branch,
		" ",
		path,
		"%=",
		right,
	})
end

local function inactive_statusline()
	local path = vim.b.rel_path or "%f"

	local right = table.concat({
		get_modified(),
		get_readonly(),
		vim.bo.filetype,
		"%l:%c",
	}, " ")

	return table.concat({
		" ",
		path,
		"%=",
		right,
	})
end

_G._statusline_active = active_statusline
_G._statusline_inactive = inactive_statusline

vim.api.nvim_create_autocmd({
	"BufEnter",
	"FocusGained",
	"DirChanged",
}, {
	callback = function()
		update_git_info()
		vim.cmd("redrawstatus!")
	end,
})

vim.api.nvim_create_autocmd({
	"WinEnter",
	"BufEnter",
}, {
	callback = function()
		vim.opt_local.statusline = "%!v:lua._statusline_active()"
	end,
})

vim.api.nvim_create_autocmd("WinLeave", {
	callback = function()
		vim.opt_local.statusline = "%!v:lua._statusline_inactive()"
	end,
})

vim.api.nvim_create_autocmd("DiagnosticChanged", {
	callback = function()
		vim.cmd("redrawstatus!")
	end,
})

vim.api.nvim_create_autocmd({
	"ModeChanged",
	"RecordingEnter",
	"RecordingLeave",
	"SearchWrapped",
}, {
	callback = function()
		vim.cmd("redrawstatus!")
	end,
})

vim.o.statusline = "%!v:lua._statusline_active()"
