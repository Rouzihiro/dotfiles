#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

ws="$(aerospace list-workspaces --focused)"

# Ensure Finder has a window and is frontmost
osascript <<'OSA'
tell application id "com.apple.finder"
  if (count windows) = 0 then
    make new Finder window
  end if
  activate
end tell
OSA

# Give macOS/AeroSpace a beat if a new window was created
sleep 0.05

# Move the focused Finder window back to the saved workspace and return there
aerospace move-node-to-workspace "$ws"
aerospace workspace "$ws"