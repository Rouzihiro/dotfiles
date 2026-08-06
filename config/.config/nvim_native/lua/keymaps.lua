local M = {}

M.registry = {}

local original_set = vim.keymap.set

function M.set(mode, lhs, rhs, opts)

    opts = opts or {}

    -- Save metadata for popup generator
    table.insert(M.registry, {
        mode = mode,
        lhs = lhs,
        desc = opts.desc or "",
        group = opts.group or "",
    })


    -- Remove custom fields before passing to nvim
    local keymap_opts = vim.deepcopy(opts)
    keymap_opts.group = nil


    original_set(
        mode,
        lhs,
        rhs,
        keymap_opts
    )

end


return M
