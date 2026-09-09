-- bookmarks.lua
-- Native macOS replacement for the rofi bookmark-launcher script,
-- built on Hammerspoon's hs.chooser (a built-in fuzzy list picker,
-- basically dmenu/rofi's UX as a first-class Hammerspoon widget).
--
-- Install: put this file at ~/.hammerspoon/bookmarks.lua and add
--   require("bookmarks")
-- to ~/.hammerspoon/init.lua (or just paste this whole file into init.lua).

local home = os.getenv("HOME")

-- --------------------------
-- Bookmark files (adjust paths as needed)
-- --------------------------
local bookmarkFiles = {
  home .. "/Documents/Notes/gaming.md",
  home .. "/Documents/Notes/links.md",
  home .. "/Documents/Notes/xxx.md",
  home .. "/Documents/Notes/coding.md",
  home .. "/Documents/Notes/movies.md",
  home .. "/Documents/Notes/work.md",
  home .. "/Documents/Notes/wallpaper.md",
  home .. "/Documents/Notes/torrent.md",
}

-- --------------------------
-- Browser fallback
-- --------------------------
-- "Brave Browser" is the .app name macOS uses to launch it via `open -a`.
-- Adjust if your brave cask installed under a different name
-- (check with: ls /Applications | grep -i brave)
local BRAVE_APP = "Brave Browser"

local function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local function tagFromPath(path)
  local base = path:match("([^/]+)$") or path
  base = base:gsub("%.%w+$", "") -- strip .md / .txt
  return base
end

local function deriveTitleFromUrl(url)
  local t = url:gsub("^https?://", ""):gsub("^www%.", ""):gsub("/.*$", "")
  t = t:gsub("%.%a+$", "")
  return t
end

-- --------------------------
-- Parse one bookmark file into chooser entries
-- --------------------------
local function loadFile(tag, path, items)
  local f = io.open(path, "r")
  if not f then return end

  for rawLine in f:lines() do
    local line = trim(rawLine)
    if line ~= "" and not line:match("^#") then
      local title, url

      if line:find("::", 1, true) then
        local sepStart, sepEnd = line:find("::", 1, true)
        title = trim(line:sub(1, sepStart - 1))
        url = trim(line:sub(sepEnd + 1))
      else
        url = line
        title = deriveTitleFromUrl(url)
      end

      -- strip trailing comments (# ... or // ...) like the original script
      url = url:gsub("%s+#.*$", ""):gsub("%s+//.*$", "")
      url = trim(url)

      table.insert(items, {
        text = string.format("[%s] %s", tag, title),
        -- subText left blank on purpose to keep the URL hidden in the list,
        -- same as the original script. Uncomment to show it instead:
        -- subText = url,
        tag = tag,
        url = url,
      })
    end
  end
  f:close()
end

local function loadBookmarks()
  local items = {}
  for _, path in ipairs(bookmarkFiles) do
    loadFile(tagFromPath(path), path, items)
  end
  table.sort(items, function(a, b) return a.text < b.text end)
  return items
end

-- --------------------------
-- Ensure URL has a scheme
-- --------------------------
local function ensureScheme(url)
  if url:match("^https?://") or url:match("^file://")
     or url:match("^about:") or url:match("^chrome:") then
    return url
  end
  return "https://" .. url
end

-- --------------------------
-- Open URL in the right app based on tag
-- --------------------------
local function openUrl(tag, url)
  url = ensureScheme(url)
  -- Mirrors the original script: every tag currently opens in Brave.
  -- Add per-tag branches here if you want different apps per bookmark file, e.g.:
  -- if tag == "work" then app = "Brave Browser" else app = "Safari" end
  local ok = hs.execute(string.format('open -a %q %q', BRAVE_APP, url))
  if not ok then
    hs.execute(string.format('open %q', url)) -- fall back to default handler
  end
end

-- --------------------------
-- The chooser itself
-- --------------------------
local bookmarkChooser = hs.chooser.new(function(choice)
  if not choice then return end
  openUrl(choice.tag, choice.url)
end)

bookmarkChooser:searchSubText(false) -- since subText is hidden/empty by default

-- --------------------------
-- Hotkey: Cmd+Alt+Space, like a rofi keybind
-- --------------------------
hs.hotkey.bind({"cmd", "alt"}, "space", function()
  bookmarkChooser:choices(loadBookmarks())
  bookmarkChooser:show()
end)
