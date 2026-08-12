-- LSP configuration for the Lua language server.
-- Requirements: lua-language-server must be on your $PATH.

return {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	settings = {
		Lua = {
			-- Neovim embeds LuaJIT, not vanilla Lua 5.1.
			runtime = { version = "LuaJIT" },
			workspace = {
				-- Don't prompt about third-party libraries.
				checkThirdParty = false,
				-- Teach the server about Neovim's Lua API so it knows about `vim.*`.
				library = { vim.env.VIMRUNTIME },
			},
		},
	},
}
