local M = {}

local config = vim.fn.stdpath("config")

local output =
  config .. "/lua/generated/keymap_hints.lua"

local md =
  config .. "/lua/generated/KEYMAPS.md"


local function ensure_dir()


  vim.fn.mkdir(
    config .. "/lua/generated",
    "p"
  )

end


-- Convert:
-- <leader>ff
-- into:
-- { "<leader>", "f", "f" }

local function tokenize(lhs)

  local tokens = {}

  while #lhs > 0 do

    local special, rest =
      lhs:match("^(%b<>)(.*)$")

    if special then

      table.insert(tokens, special)
      lhs = rest

    else

      table.insert(tokens, lhs:sub(1,1))
      lhs = lhs:sub(2)

    end

  end

  return tokens

end



local function insert(tree, keys, desc, group)

  local node = tree


  for _, key in ipairs(keys) do

    node[key] =
      node[key]
      or {}


    -- propagate group information upward
    if group and group ~= "" then
      node[key]._group = node[key]._group or group
    end


    node = node[key]

  end


  if desc and desc ~= "" then
    node._desc = desc
  end


  if group and group ~= "" then
    node._group = group
  end

end



local function build_tree(registry)

  local tree = {}


  for _, item in ipairs(registry or {}) do

    if item.lhs then

      insert(
        tree,
        tokenize(item.lhs),
        item.desc,
        item.group
      )

    end

  end


  return tree

end



local function write_lua(tree)

  local file =
    io.open(output, "w")


  if not file then
    return
  end


  file:write(
    "return ",
    vim.inspect(tree)
  )


  file:close()

end



local function mode_string(mode)

  if type(mode) == "table" then
    return table.concat(mode, ",")
  end

  return mode or ""

end



local function write_markdown(registry)

  local file =
    io.open(md, "w")


  if not file then
    return
  end


  file:write("# Neovim Keymaps\n\n")

  file:write(
    "| Mode | Key | Description | Group |\n"
  )

  file:write(
    "|---|---|---|---|\n"
  )


  for _, item in ipairs(registry or {}) do

    if item.desc and item.desc ~= "" then

      file:write(
        string.format(
          "| %s | `%s` | %s | %s |\n",
          mode_string(item.mode),
          item.lhs,
          item.desc,
          item.group or ""
        )
      )

    end

  end


  file:close()

end



function M.generate()

  ensure_dir()


  local registry =
    require("keymaps").registry or {}


  local tree =
    build_tree(registry)


  write_lua(tree)

  write_markdown(registry)

end



return M
