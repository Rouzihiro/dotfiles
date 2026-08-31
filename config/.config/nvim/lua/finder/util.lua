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
      if not line:find("\n", 1, true)
        and not line:find("\r", 1, true)
      then
        if line:match("^#!.*[ /]bash")
          or line:match("^#!.*[ /]sh")
        then
          return "sh"
        end
      end
    end
  end

  return ""
end

function M.is_binary(path)
  local ok, lines = pcall(vim.fn.readfile, path, "b", 20)

  if not ok or not lines then
    return true
  end

  for _, line in ipairs(lines) do
    if line:find("\0", 1, true) then
      return true
    end
  end

  return false
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

-- Convert arbitrary strings into valid nvim_buf_set_lines() input.
--
-- nvim_buf_set_lines() requires each table item to represent exactly
-- one line. Some files, especially unusual/binary files, can result
-- in strings containing embedded newlines.
function M.normalize_lines(lines)
  local result = {}

  for _, line in ipairs(lines or {}) do
    line = tostring(line)

    -- Split both Unix and Windows line endings.
    line = line:gsub("\r\n", "\n")
    line = line:gsub("\r", "\n")

    for part in (line .. "\n"):gmatch("(.-)\n") do
      result[#result + 1] = part
    end
  end

  return result
end

return M
