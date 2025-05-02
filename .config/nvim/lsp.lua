-- ======================
-- LSP & COMPLETION
-- ======================
local lspcfg = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Mason setup
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "bashls", "lua_ls", "ltex" }
})

-- LSP configurations
lspcfg.lua_ls.setup({ capabilities = capabilities })
lspcfg.bashls.setup({ capabilities = capabilities })
lspcfg.ltex.setup({
  capabilities = capabilities,
  settings = {
    ltex = {
      language = "en-US,de-DE",
      diagnosticSeverity = "information"
    }
  }
})

-- LTeX additional setup
require("ltex-ls").setup({
  language = "en-US,de-DE",
  dictionary = {
    ["en-US"] = { "Neovim", "LSP", "Fedora" },
    ["de-DE"] = { "GitHub", "Backend", "Frontend" }
  }
})

-- null-ls setup
local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    null_ls.builtins.diagnostics.vale.with({
      extra_args = { "--config=" .. vim.fn.expand("~/.vale.ini") },
    }),
  },
})

-- Completion
local cmp = require("cmp")
cmp.setup({
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
  }),
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
})

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- Fidget (LSP progress)
require("fidget").setup()
