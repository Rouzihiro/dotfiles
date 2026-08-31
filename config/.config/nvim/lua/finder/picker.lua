local util = require("finder.util")

local M = {}

local MAX_PREVIEW_LINES = 500

-- callback(path_or_display, open_mode) is invoked on selection.
-- open_mode is "split", "vsplit", "diff", or nil for a plain open.
function M.open(source, prompt, callback)
  local query = ""
  local items, display_items, lookup = {}, {}, {}
  local search_buf, picker_buf, preview_buf
  local search_win, picker_win, preview_win
  local closed = false
  local searching = true

  local function get_items()
    if type(source) == "function" then
      return source(query) or {}
    end
    if query == "" then
      return source or {}
    end
    return vim.fn.matchfuzzy(source or {}, query)
  end

  local function rebuild_items()
    items = get_items()
    display_items, lookup = {}, {}
    for _, item in ipairs(items) do
      local display = util.display_path(item)
      display_items[#display_items + 1] = display
      lookup[display] = item
    end
  end

  -- Dimensions --------------------------------------------------------------
  local total_width = math.floor(vim.o.columns * 0.80)
  local total_height = math.floor(vim.o.lines * 0.60)
  local picker_width = math.floor(total_width * 0.45)
  local preview_width = total_width - picker_width - 1
  local row = math.floor((vim.o.lines - total_height) / 2)
  local col = math.floor((vim.o.columns - total_width) / 2)

  -- Buffers -------------------------------------------------------------------
  search_buf = vim.api.nvim_create_buf(false, true)
  picker_buf = vim.api.nvim_create_buf(false, true)
  preview_buf = vim.api.nvim_create_buf(false, true)

  for _, buf in ipairs({ search_buf, picker_buf, preview_buf }) do
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].swapfile = false
  end
  vim.bo[picker_buf].modifiable = false
  vim.bo[preview_buf].modifiable = false

  -- Windows ---------------------------------------------------------------
  search_win = vim.api.nvim_open_win(search_buf, true, {
    relative = "editor",
    width = total_width - 2,
    height = 1,
    row = row,
    col = col + 1,
    style = "minimal",
    border = "rounded",
    title = " Search ",
    title_pos = "left",
  })

  picker_win = vim.api.nvim_open_win(picker_buf, false, {
    relative = "editor",
    width = picker_width,
    height = total_height - 2,
    row = row + 2,
    col = col,
    border = "rounded",
    title = " " .. prompt .. " ",
    title_pos = "center",
  })

  preview_win = vim.api.nvim_open_win(preview_buf, false, {
    relative = "editor",
    width = preview_width,
    height = total_height - 2,
    row = row + 2,
    col = col + picker_width + 1,
    border = "rounded",
    title = " Preview ",
    title_pos = "center",
  })

  vim.wo[search_win].number = false
  vim.wo[search_win].relativenumber = false
  vim.wo[search_win].cursorline = false
  vim.wo[search_win].signcolumn = "no"
  vim.wo[search_win].wrap = false

  -- Four spaces of comfortable padding before the search text.
  local SEARCH_PADDING = "    "
  vim.api.nvim_buf_set_lines(search_buf, 0, -1, false, { SEARCH_PADDING })

  local function get_query()
    local line = vim.api.nvim_buf_get_lines(search_buf, 0, 1, false)[1] or ""
    -- Ignore the cosmetic leading padding.
    return line:sub(#SEARCH_PADDING + 1)
  end

  -- Preview -----------------------------------------------------------------
  local function set_preview_message(message)
    if not vim.api.nvim_buf_is_valid(preview_buf) then
      return
    end
    vim.bo[preview_buf].modifiable = true
    vim.api.nvim_buf_set_lines(preview_buf, 0, -1, false, { "", " " .. message })
    vim.bo[preview_buf].modifiable = false
    vim.bo[preview_buf].filetype = ""
  end

  local function update_preview()
    if closed or not vim.api.nvim_win_is_valid(picker_win) then
      return
    end
    local line = vim.api.nvim_win_get_cursor(picker_win)[1]
    local display = display_items[line]
    local path = display and lookup[display]

    if not path then
      set_preview_message("No file selected.")
      return
    end
    if not util.can_preview(path) then
      set_preview_message("No text preview available.")
      return
    end

    local lines = vim.fn.readfile(path, "", MAX_PREVIEW_LINES)
    vim.bo[preview_buf].modifiable = true
    vim.api.nvim_buf_set_lines(preview_buf, 0, -1, false, lines)
    vim.bo[preview_buf].modifiable = false
    vim.bo[preview_buf].filetype = util.get_filetype(path)

    if vim.api.nvim_win_is_valid(preview_win) then
      vim.api.nvim_win_set_cursor(preview_win, { 1, 0 })
    end
  end

  -- Render --------------------------------------------------------------------
  local function render()
    if closed then
      return
    end
    rebuild_items()
    vim.bo[picker_buf].modifiable = true
    vim.api.nvim_buf_set_lines(picker_buf, 0, -1, false, display_items)
    vim.bo[picker_buf].modifiable = false

    if #display_items == 0 then
      set_preview_message("No matches.")
      return
    end
    vim.api.nvim_win_set_cursor(picker_win, { 1, 0 })
    update_preview()
  end

  -- Close -----------------------------------------------------------------
  local function close()
    if closed then
      return
    end
    closed = true
    for _, win in ipairs({ search_win, picker_win, preview_win }) do
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
    end
    for _, buf in ipairs({ search_buf, picker_buf, preview_buf }) do
      if vim.api.nvim_buf_is_valid(buf) then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end
  end

  -- Focus helpers -----------------------------------------------------------
  local function focus_results()
    searching = false
    if vim.api.nvim_win_is_valid(picker_win) then
      vim.api.nvim_set_current_win(picker_win)
    end
    vim.cmd("stopinsert")
  end

  local function focus_search()
    searching = true
    if not vim.api.nvim_win_is_valid(search_win) then
      return
    end
    vim.api.nvim_set_current_win(search_win)
    local line = vim.api.nvim_buf_get_lines(search_buf, 0, 1, false)[1] or ""
    vim.api.nvim_win_set_cursor(search_win, { 1, #line })
    vim.cmd("startinsert")
  end

  -- Scroll the preview window from either the search bar or the results.
  local function scroll_preview(dir)
    if not vim.api.nvim_win_is_valid(preview_win) then
      return
    end
    vim.api.nvim_win_call(preview_win, function()
      vim.cmd("normal! " .. dir)
    end)
  end

  -- Select / open_with --------------------------------------------------------
  local function current_selection()
    if not vim.api.nvim_win_is_valid(picker_win) then
      return nil
    end
    local line = vim.api.nvim_win_get_cursor(picker_win)[1]
    local display = display_items[line]
    return display, display and lookup[display]
  end

  local function select()
    if searching then
      focus_results()
      return
    end
    local display, path = current_selection()
    if not display then
      return
    end
    close()
    if path then
      callback(path)
    end
  end

  local function open_with(cmd)
    -- If still focused on search, move focus to results so cursor selection is available.
    if searching then
      focus_results()
    end
    local display, path = current_selection()
    if not display or not path then
      return
    end
    close()
    -- pass the open mode to callback: "split", "vsplit", "diff", or nil
    callback(path, cmd)
  end

  -- Search buffer keymaps -----------------------------------------------------
  local search_maps = {
    ["<Esc>"] = focus_results,
    ["<CR>"] = select,
    ["<Down>"] = function()
      focus_results()
      vim.cmd("normal! j")
    end,
    ["<C-d>"] = function() scroll_preview("<C-d>") end,
    ["<C-u>"] = function() scroll_preview("<C-u>") end,
  }
  for lhs, fn in pairs(search_maps) do
    vim.keymap.set("i", lhs, fn, { buffer = search_buf, silent = true })
  end

  -- Live search -----------------------------------------------------------
  local function update_query()
    if closed then
      return
    end
    local new_query = get_query()
    if new_query == query then
      return
    end
    query = new_query
    render()
    -- Keep focus in the search bar while typing.
    if searching and vim.api.nvim_win_is_valid(search_win) then
      vim.api.nvim_set_current_win(search_win)
    end
  end

  vim.api.nvim_create_autocmd({ "TextChangedI", "TextChanged" }, {
    buffer = search_buf,
    callback = update_query,
  })

  -- Result buffer keymaps -------------------------------------------------
  local picker_maps = {
    ["<Esc>"] = close,
    ["q"] = close,
    ["<CR>"] = select,
    ["/"] = focus_search,
    ["s"] = function() open_with("split") end, -- horizontal split
    ["v"] = function() open_with("vsplit") end, -- vertical split
    ["d"] = function() open_with("diff") end,
    ["<C-d>"] = function() scroll_preview("<C-d>") end,
    ["<C-u>"] = function() scroll_preview("<C-u>") end,
  }
  for lhs, fn in pairs(picker_maps) do
    vim.keymap.set("n", lhs, fn, { buffer = picker_buf, silent = true })
  end

  vim.api.nvim_create_autocmd("CursorMoved", {
    buffer = picker_buf,
    callback = update_preview,
  })

  -- Initial render + focus --------------------------------------------------
  render()
  vim.schedule(focus_search)
end

return M
