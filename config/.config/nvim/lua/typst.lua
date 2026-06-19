-- ~/.config/nvim/lua/typst.lua
-- Typst configuration with tinymist LSP and preview

local M = {}

-- Setup function to be called from init.lua
function M.setup()
    -- Ensure filetype detection for .typ files
    vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
        pattern = "*.typ",
        command = "set filetype=typst",
        group = vim.api.nvim_create_augroup("TypstFiletype", { clear = true })
    })

    -- Configure tinymist LSP (for Neovim 0.12+)
    local function setup_tinymist_lsp()
        -- Try to find tinymist executable
        local tinymist_cmd = nil
        
        -- Check Mason location first (most reliable for Neovim)
        local mason_bin = os.getenv("HOME") .. "/.local/share/nvim/mason/bin/tinymist"
        if vim.fn.executable(mason_bin) == 1 then
            tinymist_cmd = { mason_bin }
        -- Check cargo/bin
        elseif vim.fn.executable("tinymist") == 1 then
            tinymist_cmd = { "tinymist" }
        else
            vim.notify("tinymist not found in PATH or Mason. Install it via :MasonInstall tinymist", vim.log.levels.WARN)
            return
        end
        
        -- Simple vim.lsp.start approach for Neovim 0.12
        vim.lsp.start({
            name = 'tinymist',
            cmd = tinymist_cmd,
            filetypes = { 'typst' },
            root_dir = require('lspconfig.util').root_pattern('*.typ'),
            settings = {
                formatterMode = "typstyle",
                exportPdf = "onType",  -- Options: "onType", "onSave", "never"
                semanticTokens = "disable",
            },
            on_attach = function(client, bufnr)
                -- Enable formatting on save
                vim.api.nvim_create_autocmd("BufWritePre", {
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format({
                            async = false,
                            filter = function(c)
                                return c.name == "tinymist"
                            end
                        })
                    end,
                    group = vim.api.nvim_create_augroup("TypstFormat", { clear = true })
                })
                
                -- Pin/unpin main file for multi-file projects
                vim.keymap.set("n", "<leader>tpp", function()
                    if client and client.server_capabilities.executeCommandProvider then
                        client.request("workspace/executeCommand", {
                            command = "tinymist.pinMain",
                            arguments = { vim.api.nvim_buf_get_name(0) },
                        }, nil, bufnr)
                    end
                end, { buffer = bufnr, desc = "Pin main file" })
                
                vim.keymap.set("n", "<leader>tpu", function()
                    if client and client.server_capabilities.executeCommandProvider then
                        client.request("workspace/executeCommand", {
                            command = "tinymist.pinMain",
                            arguments = { vim.v.null },
                        }, nil, bufnr)
                    end
                end, { buffer = bufnr, desc = "Unpin main file" })
            end,
        })
    end

  
    -- Configure typst-preview plugin
    local function setup_typst_preview()
        local ok, typst_preview = pcall(require, "typst-preview")
        if not ok then
            vim.notify("typst-preview not found. Make sure it's installed.", vim.log.levels.WARN)
            return
        end
        
        typst_preview.setup({
            -- Customize preview window
            window = {
                width = 0.7,      -- 70% of screen width
                height = 0.8,     -- 80% of screen height
                border = "rounded",
                title = "Typst Preview",
                title_pos = "center",
            },
            -- Preview settings
            auto_start = false,   -- Don't auto-start preview
            sync_interval = 200,  -- Update every 200ms
            autofocus = false,    -- Don't focus preview window automatically
        })
    end

    -- Setup keymaps for Typst
    local function setup_keymaps()
        local map = vim.keymap.set
        
        -- Compilation commands
        map("n", "<leader>tcc", function()
            local filename = vim.fn.fnameescape(vim.fn.expand("%:p"))
            vim.cmd("vsplit | term tinymist compile '" .. filename .. "' --format pdf")
        end, { desc = "Compile Typst to PDF (in split)" })
        
        map("n", "<leader>tcs", function()
            local filename = vim.fn.fnameescape(vim.fn.expand("%:p"))
            vim.cmd("silent !tinymist compile '" .. filename .. "' --format pdf")
            vim.notify("Compiled " .. vim.fn.expand("%:t") .. " to PDF", vim.log.levels.INFO)
        end, { desc = "Silent compile to PDF" })
        
        map("n", "<leader>tcr", function()
            local filename = vim.fn.fnameescape(vim.fn.expand("%:p"))
            vim.cmd("silent !tinymist compile '" .. filename .. "' --format pdf --font-path ~/.local/share/fonts")
            vim.notify("Compiled with custom fonts", vim.log.levels.INFO)
        end, { desc = "Compile with custom fonts" })
        
        -- Preview commands
        map("n", "<leader>tpv", function()
            vim.cmd("TypstPreview")
            vim.notify("Typst preview started", vim.log.levels.INFO)
        end, { desc = "Start Typst preview" })
        
        map("n", "<leader>tps", function()
            vim.cmd("TypstPreviewStop")
            vim.notify("Typst preview stopped", vim.log.levels.INFO)
        end, { desc = "Stop Typst preview" })
        
        map("n", "<leader>tpr", function()
            vim.cmd("TypstPreviewRestart")
            vim.notify("Typst preview restarted", vim.log.levels.INFO)
        end, { desc = "Restart Typst preview" })
        
        map("n", "<leader>tpt", function()
            vim.cmd("TypstPreviewToggle")
        end, { desc = "Toggle Typst preview" })
        
        -- PDF viewing
        map("n", "<leader>tov", function()
            local pdf_file = vim.fn.expand("%:p:r") .. ".pdf"
            if vim.fn.filereadable(pdf_file) == 1 then
                -- Detect OS and open appropriately
                local os_name = vim.loop.os_uname().sysname
                if os_name == "Darwin" then
                    vim.system({ "open", pdf_file })
                elseif os_name == "Linux" then
                    vim.system({ "xdg-open", pdf_file })
                elseif os_name == "Windows" then
                    vim.system({ "start", pdf_file })
                end
                vim.notify("Opened PDF", vim.log.levels.INFO)
            else
                vim.notify("PDF not found. Compile first with <leader>tcs", vim.log.levels.WARN)
            end
        end, { desc = "Open PDF viewer" })
        
        -- Quick navigation between .typ and .pdf
        map("n", "<leader>tn", function()
            local current_file = vim.fn.expand("%:p")
            if current_file:match("%.typ$") then
                local pdf_file = current_file:gsub("%.typ$", ".pdf")
                if vim.fn.filereadable(pdf_file) == 1 then
                    vim.cmd("e " .. vim.fn.fnameescape(pdf_file))
                end
            elseif current_file:match("%.pdf$") then
                local typ_file = current_file:gsub("%.pdf$", ".typ")
                if vim.fn.filereadable(typ_file) == 1 then
                    vim.cmd("e " .. vim.fn.fnameescape(typ_file))
                end
            end
        end, { desc = "Toggle between .typ and .pdf" })
        
        -- LSP actions
        map("n", "K", function()
            local winid = require("ufo").peekFoldedLinesUnderCursor()
            if not winid then
                vim.lsp.buf.hover()
            end
        end, { desc = "Show documentation" })
    end

    -- Setup autocommands for Typst
    local function setup_autocommands()
        local group = vim.api.nvim_create_augroup("TypstConfig", { clear = true })
        
        -- Auto-compile on save if desired
        vim.api.nvim_create_autocmd("BufWritePost", {
            pattern = "*.typ",
            callback = function()
                -- Only auto-compile if PDF is open in a buffer
                local pdf_file = vim.fn.expand("%:p:r") .. ".pdf"
                for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                    local buf_name = vim.api.nvim_buf_get_name(buf)
                    if buf_name == pdf_file then
                        vim.cmd("silent !tinymist compile '" .. vim.fn.fnameescape(vim.fn.expand("%:p")) .. "' --format pdf")
                        break
                    end
                end
            end,
            group = group,
        })
        
        -- Set conceallevel for Typst files (hides markup characters)
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "typst",
            callback = function()
                vim.opt_local.conceallevel = 2
                vim.opt_local.spell = true  -- Enable spell check
                vim.opt_local.wrap = true   -- Wrap lines for better readability
            end,
            group = group,
        })
    end

    -- Initialize all components
    setup_tinymist_lsp()
    setup_typst_preview()
    setup_keymaps()
    setup_autocommands()
    
    vim.notify("Typst configuration loaded", vim.log.levels.INFO)
end

-- Export the module
return M
