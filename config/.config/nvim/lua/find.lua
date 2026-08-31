local M = {}

local home = vim.env.HOME

local search_roots = {
        home,
        home .. "/Downloads",
        home .. "/.config",
        home .. "/bin",
        home .. "/Documents",
        home .. "/scripts",
        home .. "/dotfiles",
}

local ignore_patterns = {
        "node_modules",
        "%.git",
        "%.cache",
        "dist",
        "build",
        "%.tmp",
        "%.log",
        "BraveSoftware",
        "mozilla",
}

local function should_ignore(path)
        for _, pattern in ipairs(ignore_patterns) do
                if path:match(pattern) then
                        return true
                end
        end

        return false
end

local function add_file(files, seen, path)
        if vim.fn.isdirectory(path) == 1 then
                return
        end

        if should_ignore(path) then
                return
        end

        local absolute = vim.fn.fnamemodify(path, ":p")

        if seen[absolute] then
                return
        end

        seen[absolute] = true
        files[#files + 1] = absolute
end

function M.global(text)
        local files = {}
        local seen = {}

        for _, root in ipairs(search_roots) do
                root = vim.fn.expand(root)

                if vim.fn.isdirectory(root) == 1 then
                        local matches = vim.fn.glob(
                                root .. "/**/*",
                                true,
                                true
                        )

                        for _, path in ipairs(matches) do
                                add_file(files, seen, path)
                        end
                end
        end

        if text == "" then
                return files
        end

        return vim.fn.matchfuzzy(files, text)
end

function M.local_(text)
        local cwd = vim.fn.getcwd()
        local files = {}
        local seen = {}

        local matches = vim.fn.glob(
                cwd .. "/*",
                true,
                true
        )

        for _, path in ipairs(matches) do
                add_file(files, seen, path)

                if vim.fn.isdirectory(path) == 1 then
                        local level_one = vim.fn.glob(
                                path .. "/*",
                                true,
                                true
                        )

                        for _, child in ipairs(level_one) do
                                add_file(files, seen, child)

                                if vim.fn.isdirectory(child) == 1 then
                                        local level_two = vim.fn.glob(
                                                child .. "/*",
                                                true,
                                                true
                                        )

                                        for _, grandchild in ipairs(level_two) do
                                                add_file(
                                                        files,
                                                        seen,
                                                        grandchild
                                                )
                                        end
                                end
                        end
                end
        end

        if text == "" then
                return files
        end

        return vim.fn.matchfuzzy(files, text)
end

-- ============================================================================
-- Native :find integration
-- ============================================================================

_G.native_find_global = M.global
_G.native_find_local = M.local_

vim.opt.findfunc = "v:lua.native_find_local"

return M
