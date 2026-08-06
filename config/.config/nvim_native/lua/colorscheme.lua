vim.pack.add({
   { src = "https://github.com/GooseRooster/osc-colors.nvim" },
})

require("osc-colors").setup({
    capabilities = {
        truecolor = true,
        undercurl = false,
        terminal_colors = true,
    },

    ui = {
        transparent = true,
        dim_inactive = false,
    },

    styles = {
        comments  = { italic = true },
        keywords  = {},
        functions = {},
        variables = {},
        types     = {},
    },

    highlights = {
        integrations = {
            telescope = true,
            notify    = true,
            cmp       = true,
            blink     = true,
            dapui     = true,
            lualine   = true,
            snacks    = true,
        },
        use_lazy_specs = true,
    },

    refresh_on = { "UIEnter", "FocusGained" },
})
