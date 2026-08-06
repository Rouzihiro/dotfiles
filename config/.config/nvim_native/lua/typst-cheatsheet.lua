-- ~/.config/nvim/lua/typst-cheatsheet.lua
-- Typst keybindings cheatsheet

local function show_cheatsheet()
    local cheatsheet = {
        "══════════════════════════════════════════",
        "           TYPST KEYBINDINGS              ",
        "══════════════════════════════════════════",
        " Compilation:",
        "  <leader>tcs - Silent compile to PDF",
        "  <leader>tcc - Compile in split terminal",
        "  <leader>tcr - Compile with custom fonts",
        "",
        " Preview:",
        "  <leader>tpv - Start live preview",
        "  <leader>tps - Stop preview",
        "  <leader>tpr - Restart preview",
        "  <leader>tpt - Toggle preview",
        "",
        " PDF Viewing:",
        "  <leader>tov - Open PDF in system viewer",
        "  <leader>tn  - Toggle between .typ/.pdf",
        "",
        " LSP & Project:",
        "  <leader>tpp - Pin main file (multi-file)",
        "  <leader>tpu - Unpin main file",
        "  K          - Show documentation",
        "══════════════════════════════════════════",
    }
    
    vim.notify(table.concat(cheatsheet, "\n"), vim.log.levels.INFO, {
        title = "Typst Commands",
        timeout = 10000,  -- Show for 10 seconds
    })
end

-- Add a command to show the cheatsheet
vim.api.nvim_create_user_command("TypstHelp", show_cheatsheet, {
    desc = "Show Typst keybindings cheatsheet"
})

-- Optionally bind it to a key
vim.keymap.set("n", "<leader>th", show_cheatsheet, { desc = "Typst help" })

return {
    show_cheatsheet = show_cheatsheet
}
