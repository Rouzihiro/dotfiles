local M = {}

function M.display_path(path)
  return vim.fn.fnamemodify(path, ":~:.")
end

function M.get_filetype(path)
  local filetype = vim.filetype.match({ filename = path })
  if filetype then
    return filetype
  end
  -- Detect extensionless shell scripts from their shebang.
  local ok, lines = pcall(vim.fn.readfile, path, "", 2)
  if ok and lines then
    for _, line in ipairs(lines) do
      if line:match("^#!.*[ /]bash") or line:match("^#!.*[ /]sh") then
        return "sh"
      end
    end
  end
  return ""
end

function M.is_binary(path)
  local ok, lines = pcall(vim.fn.readfile, path, "b", 1)
  if not ok or not lines or #lines == 0 then
    return false
  end
  return lines[1]:find("\0", 1, true) ~= nil
end

function M.can_preview(path)
  if not path or path == "" then
    return false
  end
  if vim.fn.filereadable(path) ~= 1 then
    return false
  end
  return not M.is_binary(path)
end

return M
