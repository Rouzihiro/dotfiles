local M = {}

local hints =
  require("generated.keymap_hints")


local active = false
local path = {}

local buf = nil
local win = nil


local function close()

  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_close(win, true)
  end

  win = nil
  buf = nil

end



local function get_node()

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

    if key ~= "_desc" then
      table.insert(keys, key)
    end

  end


  table.sort(keys)

  return keys

end



local function render()

  local node =
    get_node()


  if not node then
    close()
    return
  end



  local lines = {}


  for _, key in ipairs(sorted_keys(node)) do

    local child =
      node[key]

local desc =
  child._desc
  or child._group
  or ""

    table.insert(
      lines,
      string.format(
        " %s  %s",
        key,
        desc
      )
    )

  end



  if #lines == 0 then

    close()
    return

  end



  close()



  buf =
    vim.api.nvim_create_buf(
      false,
      true
    )


  vim.api.nvim_buf_set_lines(
    buf,
    0,
    -1,
    false,
    lines
  )



  local width = 0

  for _, line in ipairs(lines) do

    width =
      math.max(
        width,
        #line
      )

  end



  win =
    vim.api.nvim_open_win(
      buf,
      false,
      {
        relative = "cursor",
        row = 1,
        col = 0,
        width = width + 2,
        height = #lines,
        border = "rounded",
        style = "minimal",
      }
    )

end



local function reset()

  active = false
  path = {}

  close()

end



local function add_key(char)

  table.insert(
    path,
    vim.fn.keytrans(char)
  )

end



function M.start()

  vim.on_key(function(char)

    if vim.api.nvim_get_mode().mode:match("^i") then
      reset()
      return
    end

    if char == "<Esc>" then
      reset()
      return
    end

    if char == " " then

      active = true
      path = {
        "<leader>"
      }

      render()

      return
    end



    if not active then
      return
    end



    add_key(char)



    if get_node() then

      render()

    else

      reset()

    end


  end)

end


return M
