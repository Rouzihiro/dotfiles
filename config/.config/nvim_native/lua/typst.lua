local M = {}

function M.setup()
	local function setup_tinymist_lsp()
		local cmd = nil

		local mason = vim.fn.expand("~/.local/share/nvim/mason/bin/tinymist")

		if vim.fn.executable(mason) == 1 then
			cmd = { mason }
		elseif vim.fn.executable("tinymist") == 1 then
			cmd = { "tinymist" }
		else
			vim.notify("tinymist not found", vim.log.levels.WARN)
			return
		end

		vim.lsp.start({

			name = "tinymist",

			cmd = cmd,

			filetypes = {
				"typst",
			},

			root_dir = function(bufnr)
				local fname = vim.api.nvim_buf_get_name(bufnr)

				return vim.fs.root(fname, {
					".git",
					"*.typ",
				}) or vim.fn.fnamemodify(fname, ":p:h")
			end,

			settings = {

				formatterMode = "typstyle",

				exportPdf = "onType",

				semanticTokens = "disable",
			},

			on_attach = function(client, bufnr)
				vim.api.nvim_create_autocmd("BufWritePre", {
					buffer = bufnr,

					callback = function()
						vim.lsp.buf.format({
							async = false,

							filter = function(c)
								return c.name == "tinymist"
							end,
						})
					end,
				})

				vim.keymap.set("n", "<leader>tpp", function()
					client.request("workspace/executeCommand", {
						command = "tinymist.pinMain",

						arguments = {
							vim.api.nvim_buf_get_name(0),
						},
					}, nil, bufnr)
				end, {
					buffer = bufnr,
					desc = "Pin Typst main file",
				})

				vim.keymap.set("n", "<leader>tpu", function()
					client.request("workspace/executeCommand", {
						command = "tinymist.pinMain",

						arguments = {
							vim.NIL,
						},
					}, nil, bufnr)
				end, {
					buffer = bufnr,
					desc = "Unpin Typst main file",
				})
			end,
		})
	end

	local function setup_keymaps()
		local map = vim.keymap.set

		map("n", "<leader>tcc", function()
			local file = vim.fn.expand("%:p")

			vim.cmd("vsplit | terminal tinymist compile " .. vim.fn.shellescape(file) .. " --format pdf")
		end, {
			desc = "Compile Typst PDF split",
		})

		map("n", "<leader>tcs", function()
			local file = vim.fn.expand("%:p")

			vim.system({
				"tinymist",
				"compile",
				file,
				"--format",
				"pdf",
			})

			vim.notify("Typst compiled", vim.log.levels.INFO)
		end, {
			desc = "Compile Typst PDF",
		})

		map("n", "<leader>tov", function()
			local pdf = vim.fn.expand("%:p:r") .. ".pdf"

			if vim.fn.filereadable(pdf) == 1 then
				vim.system({
					"xdg-open",
					pdf,
				})
			else
				vim.notify("PDF not found", vim.log.levels.WARN)
			end
		end, {
			desc = "Open PDF",
		})

		map("n", "<leader>tn", function()
			local file = vim.fn.expand("%:p")

			if file:match("%.typ$") then
				local pdf = file:gsub("%.typ$", ".pdf")

				if vim.fn.filereadable(pdf) == 1 then
					vim.cmd("edit " .. vim.fn.fnameescape(pdf))
				end
			elseif file:match("%.pdf$") then
				local typ = file:gsub("%.pdf$", ".typ")

				if vim.fn.filereadable(typ) == 1 then
					vim.cmd("edit " .. vim.fn.fnameescape(typ))
				end
			end
		end, {
			desc = "Toggle typ/pdf",
		})

		map("n", "K", function()
			vim.lsp.buf.hover()
		end, {
			desc = "Typst documentation",
		})
	end

	local function setup_autocmds()
		local group = vim.api.nvim_create_augroup("TypstConfig", {
			clear = true,
		})

		vim.api.nvim_create_autocmd("FileType", {
			group = group,

			pattern = "typst",

			callback = function()
				vim.opt_local.conceallevel = 2
				vim.opt_local.spell = true
				vim.opt_local.wrap = true
			end,
		})
	end

	vim.api.nvim_create_autocmd({
		"BufRead",
		"BufNewFile",
	}, {
		group = vim.api.nvim_create_augroup("TypstFiletype", {
			clear = true,
		}),

		pattern = "*.typ",

		callback = function()
			vim.bo.filetype = "typst"

			if not vim.g.typst_loaded then
				vim.g.typst_loaded = true

				setup_tinymist_lsp()

				setup_keymaps()

				setup_autocmds()

				vim.notify("Typst configuration loaded", vim.log.levels.INFO)
			end
		end,
	})
end

return M
