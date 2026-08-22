local M = {}

-- Opens a file path in the given mode. `mode` is one of:
-- "split", "vsplit", "diff", or nil/"" for a plain edit.
function M.open_file(path, mode)
  if mode == "diff" then
    local current_file = vim.api.nvim_buf_get_name(0)
    if current_file == "" then
      vim.notify("Current buffer has no file", vim.log.levels.WARN)
      return
    end
    if vim.fn.filereadable(current_file) ~= 1 then
      vim.notify("Current buffer is not a readable file", vim.log.levels.WARN)
      return
    end
    require("difftool").open(current_file, path)
  elseif mode == "split" then
    vim.cmd("split " .. vim.fn.fnameescape(path))
  elseif mode == "vsplit" then
    vim.cmd("vsplit " .. vim.fn.fnameescape(path))
  else
    vim.cmd("edit " .. vim.fn.fnameescape(path))
  end
end

-- Switches to an already-loaded buffer in the given mode.
-- Buffers have no "diff" mode since there's no path to diff against.
function M.open_buffer(buf, mode)
  if not buf or not vim.api.nvim_buf_is_valid(buf) then
    return
  end
  if mode == "split" then
    vim.cmd("split")
    vim.api.nvim_set_current_buf(buf)
  elseif mode == "vsplit" then
    vim.cmd("vsplit")
    vim.api.nvim_set_current_buf(buf)
  else
    vim.api.nvim_set_current_buf(buf)
  end
end

return M
