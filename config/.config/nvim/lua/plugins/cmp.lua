-- ============================
-- ✨ Completion Setup (nvim-cmp)
-- ============================

local cmp = require("cmp")

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- confirm selection
    ['<Tab>'] = cmp.mapping.select_next_item(),        -- next suggestion
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),      -- previous suggestion
  }),
  sources = {
    { name = 'path' },    -- file paths
    { name = 'buffer' },  -- buffer words
    { name = 'nvim_lsp' } -- language server
  },
})
