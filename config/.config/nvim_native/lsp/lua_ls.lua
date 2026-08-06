-- LSP configuration for the Lua language server.
--
-- Neovim 0.11+ uses `vim.lsp.enable()` which automatically picks up files
-- inside the `lsp/` folder. This file is returned as a Lua table and Neovim
-- passes it straight to the LSP client.
--
-- Requirements: lua-language-server must be on your $PATH.
--   brew install lua-language-server

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
