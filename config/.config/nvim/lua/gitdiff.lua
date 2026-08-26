-- gitdiff.lua
local M = {}
local state = { win = nil, buf = nil }

---@param path string
---@return string? root
---@return string? rel
local function git_root_relative(path)
  local root = vim.fn.systemlist('git -C ' .. vim.fn.fnamemodify(path, ':h:S')
    .. ' rev-parse --show-toplevel')[1]
  if vim.v.shell_error ~= 0 or not root then return nil end
  return root, path:sub(#root + 2)
end

local function close_diff()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    for _, w in ipairs(vim.api.nvim_list_wins()) do
      if w ~= state.win and vim.api.nvim_win_is_valid(w) then
        pcall(vim.api.nvim_win_call, w, function() vim.cmd('diffoff') end)
      end
    end
    vim.api.nvim_win_close(state.win, true)
  end
  if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
    vim.api.nvim_buf_delete(state.buf, { force = true })
  end
  state.win, state.buf = nil, nil
end

function M.toggle_diff_head(ref)
  ref = ref or 'HEAD'

  if state.win and vim.api.nvim_win_is_valid(state.win) then
    close_diff()
    return
  end

  local path = vim.api.nvim_buf_get_name(0)
  local root, rel = git_root_relative(path)
  if not root or not rel then
    vim.notify('Not in a git repo', vim.log.levels.WARN)
    return
  end

  local out = vim.fn.systemlist(
    string.format('git -C %s show %s:./%s', vim.fn.shellescape(root), ref, vim.fn.shellescape(rel))
  )
  local is_new_file = vim.v.shell_error ~= 0
  if is_new_file then
    out = {}
    vim.notify('New/untracked file — diffing against empty', vim.log.levels.INFO)
  end

  local cur_win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, out)
  vim.api.nvim_set_option_value('filetype', vim.bo.filetype, { buf = buf })
  vim.api.nvim_buf_set_name(buf, (is_new_file and '(empty)' or (ref .. ':')) .. rel)

  vim.cmd('leftabove vsplit')
  vim.api.nvim_win_set_buf(0, buf)
  vim.cmd('diffthis')

  state.win = vim.api.nvim_get_current_win()
  state.buf = buf

  vim.api.nvim_set_current_win(cur_win)
  vim.cmd('diffthis')

  vim.api.nvim_create_autocmd('WinClosed', {
    pattern = tostring(state.win),
    once = true,
    callback = function()
      if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
        pcall(vim.api.nvim_buf_delete, state.buf, { force = true })
      end
      state.win, state.buf = nil, nil
      pcall(function() vim.cmd('diffoff') end)
    end,
  })
end

M.diff_head = M.toggle_diff_head

return M
