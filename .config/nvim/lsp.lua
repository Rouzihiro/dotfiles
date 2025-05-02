-- ======================
-- LSP & COMPLETION CONFIG
-- ======================

-- Ensure vim global is recognized (fixes warnings)
vim = vim or {}

-- LSP Setup
local lspcfg = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- ======================
-- MASON (LSP INSTALLER)
-- ======================
require("mason").setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})

require("mason-lspconfig").setup({
  ensure_installed = { "bashls", "lua_ls", "ltex" },
  automatic_installation = true,
})

-- ======================
-- LSP SERVERS
-- ======================

-- Lua LSP (special configuration)
lspcfg.lua_ls.setup({
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = {'vim'},
      },
      workspace = {
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
        },
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    }
  }
})

-- Bash LSP
lspcfg.bashls.setup({ capabilities = capabilities })

-- LTeX (Grammar/Spell Check)
lspcfg.ltex.setup({
  capabilities = capabilities,
  settings = {
    ltex = {
      language = "en-US,de-DE",
      diagnosticSeverity = "information",
      dictionary = {
        ["en-US"] = { "Neovim", "LSP", "Fedora" },
        ["de-DE"] = { "GitHub", "Backend", "Frontend" }
      }
    }
  }
})

-- ======================
-- NULL-LS (DIAGNOSTICS/FORMATTING)
-- ======================
local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    null_ls.builtins.diagnostics.vale.with({
      extra_args = { "--config=" .. vim.fn.expand("~/.vale.ini") },
    }),
  },
})

-- ======================
-- COMPLETION (CMP)
-- ======================
local cmp = require('cmp')

cmp.setup({
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
  }),
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
})

-- ======================
-- LSP DIAGNOSTICS CONFIG
-- ======================
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    focusable = false,
    style = 'minimal',
    border = 'rounded',
    source = true,
  },
})

-- ======================
-- LSP HIGHLIGHTS
-- ======================
vim.api.nvim_create_augroup('lsp_document_highlight', {})
vim.api.nvim_create_autocmd('LspAttach', {
  group = 'lsp_document_highlight',
  callback = function(args)
    vim.api.nvim_create_autocmd('CursorHold', {
      buffer = args.buf,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd('CursorMoved', {
      buffer = args.buf,
      callback = vim.lsp.buf.clear_references,
    })
  end,
})

-- ======================
-- FIDGET (LSP PROGRESS) - Guaranteed Working Config
-- ======================
require('fidget').setup({}) -- Use all defaults
