local M = {}

local hints =
  require("generated.keymap_hints")

local buf = nil
local win = nil


local function close()

  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_close(win, true)
    -- force the terminal to repaint now; without this the closed
    -- window's contents can linger on screen until something else
    -- happens to trigger a redraw
    vim.cmd("redraw")
  end

  win = nil
  buf = nil

end


local function get_node(path)

  local node = hints

  for _, key in ipairs(path) do

    node = node[key]

    if not node then
      return nil
    end

  end

  return node

end


local function sorted_keys(node)

  local keys = {}

  for key, _ in pairs(node) do

    if key ~= "_desc" and key ~= "_group" then
      table.insert(keys, key)
    end

  end

  table.sort(keys)

  return keys

end


-- Renders the popup for a given node. Returns the number of
-- selectable children (0 means this node is a leaf).
local function render(node)

  local lines = {}

  for _, key in ipairs(sorted_keys(node)) do

    local child = node[key]

    local desc =
      child._desc
      or child._group
      or ""

    table.insert(
      lines,
      string.format(" %s  %s", key, desc)
    )

  end

  close()

  if #lines == 0 then
    return 0
  end

  buf = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  local width = 0

  for _, line in ipairs(lines) do
    width = math.max(width, #line)
  end

  win = vim.api.nvim_open_win(buf, false, {
    relative = "cursor",
    row = 1,
    col = 0,
    width = width + 2,
    height = #lines,
    border = "rounded",
    style = "minimal",
  })

  -- about to block on getcharstr(); force this onto the screen now
  vim.cmd("redraw")

  return #lines

end


-- Looks up the live registry (not the generated hints file, which
-- only holds display data) to find the actual rhs for a completed
-- key sequence.
local function find_mapping(lhs)

  local registry = require("keymaps").registry

  for _, item in ipairs(registry) do

    if item.lhs == lhs then

      local mode = item.mode

      if mode == "n" or mode == nil
        or (type(mode) == "table" and vim.tbl_contains(mode, "n")) then
        return item
      end

    end

  end

  return nil

end


-- Executes the resolved mapping directly. Never touches Neovim's
-- own mapping/timeout engine for the leader key, so there is no
-- risk of re-triggering M.start recursively.
local function dispatch(lhs)

  local mapping = find_mapping(lhs)

  if not mapping or not mapping.rhs then
    return
  end

  if type(mapping.rhs) == "function" then

    mapping.rhs()

  else

    local keys =
      vim.api.nvim_replace_termcodes(mapping.rhs, true, true, true)

    vim.api.nvim_feedkeys(keys, "n", true)

  end

end


-- Drives its own key-capture loop instead of relying on
-- Neovim's mapping engine / timeoutlen to resolve the sequence.
function M.start()

  local display_path = { "<leader>" }

  local node = get_node(display_path)

  if not node then
    return
  end

  render(node)

  while true do

    local ok, char = pcall(vim.fn.getcharstr)

    if not ok or char == "\27" then -- read failed or <Esc>
      close()
      return
    end

    table.insert(display_path, vim.fn.keytrans(char))

    node = get_node(display_path)

    if not node then
      close() -- dead end, no such mapping
      return
    end

    if render(node) == 0 then

      close()
      dispatch(table.concat(display_path))
      return

    end

  end

end


function M.setup()
  vim.keymap.set("n", "<leader>", M.start, { desc = "Show keymap hints" })
end


return M
