return {
	{
		"bjarneo/pixel.nvim",
		name = "pixel",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("pixel")
		end,
	},
}
