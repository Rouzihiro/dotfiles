local picker = require("finder.picker")
local actions = require("finder.actions")
local util = require("finder.util")

local M = {}

-- ============================================================================
-- Files
-- ============================================================================
function M.files(local_search)
  local native_find = require("find")
  local finder = local_search and native_find.local_ or native_find.global
  picker.open(
    finder,
    local_search and "Find files" or "Find files globally",
    actions.open_file
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
  picker.open(files, "Recent files", actions.open_file)
end

-- ============================================================================
-- Buffers
-- ============================================================================
function M.buffers()
  local files, lookup = {}, {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
      local name = vim.api.nvim_buf_get_name(buf)
      if name ~= "" then
        local display = util.display_path(name)
        files[#files + 1] = display
        lookup[display] = buf
      end
    end
  end
  picker.open(files, "Buffers", function(display, mode)
    actions.open_buffer(lookup[display], mode)
  end)
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
    "rg", "--vimgrep", "--smart-case", "--hidden",
    "--glob", "!.git",
    "--glob", "!node_modules",
    "--glob", "!.cache",
    "--glob", "!dist",
    "--glob", "!build",
    "--", text, ".",
  })

  if #results == 0 then
    vim.notify("No matches found", vim.log.levels.INFO)
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
