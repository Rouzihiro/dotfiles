local M = {}

local MAX_PREVIEW_LINES = 500

-- ============================================================================
-- Helpers
-- ============================================================================

local function display_path(path)
        return vim.fn.fnamemodify(path, ":~:.")
end

local function get_filetype(path)
        return vim.filetype.match({
                filename = path,
        }) or ""
end

local function is_binary(path)
        local ok, lines = pcall(vim.fn.readfile, path, "b", 1)

        if not ok or not lines or #lines == 0 then
                return false
        end

        return lines[1]:find("\0", 1, true) ~= nil
end

local function can_preview(path)
        if not path or path == "" then
                return false
        end

        if vim.fn.filereadable(path) ~= 1 then
                return false
        end

        if is_binary(path) then
                return false
        end

        return true
end

local function set_preview_message(buf, message)
        if not vim.api.nvim_buf_is_valid(buf) then
                return
        end

        vim.bo[buf].modifiable = true

        vim.api.nvim_buf_set_lines(
                buf,
                0,
                -1,
                false,
                {
                        "",
                        "  " .. message,
                }
        )

        vim.bo[buf].modifiable = false
        vim.bo[buf].filetype = ""
end

-- ============================================================================
-- Picker
-- ============================================================================

local function open_picker(source, prompt, callback)
        local query = ""
        local items = {}
        local display_items = {}
        local lookup = {}

        local picker_buf
        local preview_buf
        local picker_win
        local preview_win

        local closed = false

        -- --------------------------------------------------------------------
        -- Source
        -- --------------------------------------------------------------------

        local function get_items()
                if type(source) == "function" then
                        return source(query) or {}
                end

                return source or {}
        end

        -- --------------------------------------------------------------------
        -- Build display list
        -- --------------------------------------------------------------------

        local function rebuild_items()
                items = get_items()
                display_items = {}
                lookup = {}

                for _, item in ipairs(items) do
                        local display = display_path(item)

                        display_items[#display_items + 1] = display
                        lookup[display] = item
                end
        end

        -- --------------------------------------------------------------------
        -- Window dimensions
        -- --------------------------------------------------------------------

        local total_width = math.floor(vim.o.columns * 0.80)
        local total_height = math.floor(vim.o.lines * 0.60)

        local picker_width = math.floor(total_width * 0.45)
        local preview_width = total_width - picker_width - 1

        local row = math.floor(
                (vim.o.lines - total_height) / 2
        )

        local col = math.floor(
                (vim.o.columns - total_width) / 2
        )

        -- --------------------------------------------------------------------
        -- Buffers
        -- --------------------------------------------------------------------

        picker_buf = vim.api.nvim_create_buf(false, true)
        preview_buf = vim.api.nvim_create_buf(false, true)

        vim.bo[picker_buf].bufhidden = "wipe"
        vim.bo[picker_buf].buftype = "nofile"
        vim.bo[picker_buf].swapfile = false
        vim.bo[picker_buf].modifiable = false

        vim.bo[preview_buf].bufhidden = "wipe"
        vim.bo[preview_buf].buftype = "nofile"
        vim.bo[preview_buf].swapfile = false
        vim.bo[preview_buf].modifiable = false

        -- --------------------------------------------------------------------
        -- Windows
        -- --------------------------------------------------------------------

        picker_win = vim.api.nvim_open_win(
                picker_buf,
                true,
                {
                        relative = "editor",
                        width = picker_width,
                        height = total_height,
                        row = row,
                        col = col,
                        border = "rounded",
                        title = " " .. prompt .. " ",
                        title_pos = "center",
                }
        )

        preview_win = vim.api.nvim_open_win(
                preview_buf,
                false,
                {
                        relative = "editor",
                        width = preview_width,
                        height = total_height,
                        row = row,
                        col = col + picker_width + 1,
                        border = "rounded",
                        title = " Preview ",
                        title_pos = "center",
                }
        )

        -- --------------------------------------------------------------------
        -- Preview
        -- --------------------------------------------------------------------

        local function update_preview()
                if closed then
                        return
                end

                if not vim.api.nvim_win_is_valid(picker_win) then
                        return
                end

                local line = vim.api.nvim_win_get_cursor(picker_win)[1]
                local display = display_items[line]

                if not display then
                        set_preview_message(
                                preview_buf,
                                "No file selected."
                        )
                        return
                end

                local path = lookup[display]

                if not path then
                        set_preview_message(
                                preview_buf,
                                "No file selected."
                        )
                        return
                end

                if not can_preview(path) then
                        set_preview_message(
                                preview_buf,
                                "No text preview available."
                        )
                        return
                end

                local lines = vim.fn.readfile(
                        path,
                        "",
                        MAX_PREVIEW_LINES
                )

                vim.bo[preview_buf].modifiable = true

                vim.api.nvim_buf_set_lines(
                        preview_buf,
                        0,
                        -1,
                        false,
                        lines
                )

                vim.bo[preview_buf].modifiable = false

                vim.bo[preview_buf].filetype = get_filetype(path)

                if vim.api.nvim_win_is_valid(preview_win) then
                        vim.api.nvim_win_set_cursor(
                                preview_win,
                                { 1, 0 }
                        )
                end
        end

        -- --------------------------------------------------------------------
        -- Render
        -- --------------------------------------------------------------------

        local function render()
                if closed then
                        return
                end

                rebuild_items()

                vim.bo[picker_buf].modifiable = true

                vim.api.nvim_buf_set_lines(
                        picker_buf,
                        0,
                        -1,
                        false,
                        display_items
                )

                vim.bo[picker_buf].modifiable = false

                if #display_items == 0 then
                        set_preview_message(
                                preview_buf,
                                "No matches."
                        )
                        return
                end

                vim.api.nvim_win_set_cursor(
                        picker_win,
                        { 1, 0 }
                )

                update_preview()
        end

        -- --------------------------------------------------------------------
        -- Close
        -- --------------------------------------------------------------------

        local function close()
                if closed then
                        return
                end

                closed = true

                if vim.api.nvim_win_is_valid(picker_win) then
                        vim.api.nvim_win_close(picker_win, true)
                end

                if vim.api.nvim_win_is_valid(preview_win) then
                        vim.api.nvim_win_close(preview_win, true)
                end

                if vim.api.nvim_buf_is_valid(picker_buf) then
                        vim.api.nvim_buf_delete(
                                picker_buf,
                                { force = true }
                        )
                end

                if vim.api.nvim_buf_is_valid(preview_buf) then
                        vim.api.nvim_buf_delete(
                                preview_buf,
                                { force = true }
                        )
                end
        end

        -- --------------------------------------------------------------------
        -- Selection
        -- --------------------------------------------------------------------

        local function select()
                local line = vim.api.nvim_win_get_cursor(
                        picker_win
                )[1]

                local display = display_items[line]

                if not display then
                        return
                end

                local path = lookup[display]

                close()

                if path then
                        callback(path)
                end
        end

        -- --------------------------------------------------------------------
        -- Search
        -- --------------------------------------------------------------------

        local function search()
                vim.ui.input({
                        prompt = "Search: ",
                        default = query,
                }, function(input)
                        if input == nil then
                                return
                        end

                        query = input

                        render()

                        if vim.api.nvim_win_is_valid(picker_win) then
                                vim.api.nvim_set_current_win(
                                        picker_win
                                )
                        end
                end)
        end

        -- --------------------------------------------------------------------
        -- Keymaps
        -- --------------------------------------------------------------------

        vim.keymap.set("n", "<Esc>", close, {
                buffer = picker_buf,
                silent = true,
                desc = "Close picker",
        })

        vim.keymap.set("n", "q", close, {
                buffer = picker_buf,
                silent = true,
                desc = "Close picker",
        })

        vim.keymap.set("n", "<CR>", select, {
                buffer = picker_buf,
                silent = true,
                desc = "Open selected file",
        })

        vim.keymap.set("n", "/", search, {
                buffer = picker_buf,
                silent = true,
                desc = "Search",
        })

        -- Preview scrolling while keeping the picker active.
        vim.keymap.set("n", "<C-d>", function()
                if vim.api.nvim_win_is_valid(preview_win) then
                        vim.api.nvim_win_call(
                                preview_win,
                                function()
                                        vim.cmd("normal! <C-d>")
                                end
                        )
                end
        end, {
                buffer = picker_buf,
                silent = true,
                desc = "Scroll preview down",
        })

        vim.keymap.set("n", "<C-u>", function()
                if vim.api.nvim_win_is_valid(preview_win) then
                        vim.api.nvim_win_call(
                                preview_win,
                                function()
                                        vim.cmd("normal! <C-u>")
                                end
                        )
                end
        end, {
                buffer = picker_buf,
                silent = true,
                desc = "Scroll preview up",
        })

        -- --------------------------------------------------------------------
        -- Cursor movement → preview
        -- --------------------------------------------------------------------

        vim.api.nvim_create_autocmd("CursorMoved", {
                buffer = picker_buf,
                callback = function()
                        update_preview()
                end,
        })

        -- --------------------------------------------------------------------
        -- Initial render
        -- --------------------------------------------------------------------

        render()
end

-- ============================================================================
-- Files
-- ============================================================================

function M.files(local_search)
        local native_find = require("find")

        local finder

        if local_search then
                finder = native_find.local_
        else
                finder = native_find.global
        end

        open_picker(
                finder,
                local_search and "Find files" or "Find files globally",
                function(file)
                        vim.cmd("edit " .. vim.fn.fnameescape(file))
                end
        )
end

-- ============================================================================
-- Recent files
-- ============================================================================

function M.oldfiles()
        local files = {}

        for _, file in ipairs(vim.v.oldfiles) do
                if vim.fn.filereadable(file) == 1 then
                        files[#files + 1] = file
                end
        end

        open_picker(
                files,
                "Recent files",
                function(file)
                        vim.cmd("edit " .. vim.fn.fnameescape(file))
                end
        )
end

-- ============================================================================
-- Buffers
-- ============================================================================

function M.buffers()
        local files = {}
        local lookup = {}

        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                if vim.api.nvim_buf_is_loaded(buf)
                        and vim.bo[buf].buflisted
                then
                        local name = vim.api.nvim_buf_get_name(buf)

                        if name ~= "" then
                                local display = display_path(name)

                                files[#files + 1] = display
                                lookup[display] = buf
                        end
                end
        end

        open_picker(
                files,
                "Buffers",
                function(display)
                        local buf = lookup[display]

                        if buf and vim.api.nvim_buf_is_valid(buf) then
                                vim.api.nvim_set_current_buf(buf)
                        end
                end
        )
end

-- ============================================================================
-- Grep
-- ============================================================================

function M.grep()
        local text = vim.fn.input("Search: ")

        if text == "" then
                return
        end

        local results = vim.fn.systemlist({
                "rg",
                "--vimgrep",
                "--smart-case",
                "--hidden",
                "--glob",
                "!.git",
                "--glob",
                "!node_modules",
                "--glob",
                "!.cache",
                "--glob",
                "!dist",
                "--glob",
                "!build",
                "--",
                text,
                ".",
        })

        if #results == 0 then
                vim.notify(
                        "No matches found",
                        vim.log.levels.INFO
                )
                return
        end

        vim.fn.setqflist({}, " ", {
                title = "rg: " .. text,
                lines = results,
                efm = "%f:%l:%c:%m",
        })

        vim.cmd("copen")
end

return M
