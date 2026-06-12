#!/usr/bin/env bash
# dashboard.sh — stats pane (left), runs in a loop
# Called internally by dashboard-launch.sh — not meant to be run directly
# deps: gum, all your sb-* / status scripts in $PATH

# ── Colors ────────────────────────────────────────────────────────────────────
CLR_HEAD="#d7ccc8"
CLR_VAL="#bcaaa4"
CLR_DIM="#8d6e63"
CLR_SEP="#3e2723"

# ── Helpers ───────────────────────────────────────────────────────────────────
header() {
  gum style \
    --foreground "$CLR_HEAD" \
    --border-foreground "$CLR_DIM" \
    --border normal \
    --padding "0 1" \
    --bold \
    "$1"
}

row() {
  local label="$1"
  local value="$2"
  local color="${3:-$CLR_VAL}"
  printf "  "
  printf "%-14s" "$(gum style --foreground "$CLR_DIM" "$label")"
  gum style --foreground "$color" "$value"
}

sep() {
  gum style --foreground "$CLR_SEP" "$(printf '─%.0s' {1..40})"
}

# ── Main loop ─────────────────────────────────────────────────────────────────
while true; do
  # Gather
  SYS_CPU=$(cpu-usage    2>/dev/null || echo "n/a")
  SYS_MEM=$(memory       2>/dev/null || echo "n/a")
  SYS_DISK=$(df -h / | awk 'NR==2 {print $3 "/" $2 " (" $5 ")"}')
  SYS_BW=$(bandwith      2>/dev/null || echo "n/a")
  NET_WIFI=$(wifi-status 2>/dev/null || echo "n/a")
  NET_WX=$(weather-short 2>/dev/null || echo "n/a")
  AV_VOL=$(sb-volume     2>/dev/null || echo "n/a")
  AV_BRIGHT=$(sb-brightness 2>/dev/null || echo "n/a")
  SYS_POWER=$(power-wrapper 2>/dev/null || echo "n/a")
  SYS_KB=$(kb-layout     2>/dev/null || echo "n/a")
  SYS_BATT=$(battery2    2>/dev/null || echo "n/a")
  SYS_TIME=$(timer       2>/dev/null || date '+%H:%M:%S')

  # Render to buffer first, then swap — avoids flicker
  OUTPUT=""
  OUTPUT+="\n"
  OUTPUT+="$(gum style --foreground "$CLR_HEAD" --bold --align center --width 42 ' DASHBOARD')\n"
  OUTPUT+="$(sep)\n\n"

  OUTPUT+="$(header '  Resources')\n"
  OUTPUT+="$(row 'CPU'       "$SYS_CPU")\n"
  OUTPUT+="$(row 'Memory'    "$SYS_MEM")\n"
  OUTPUT+="$(row 'Disk (/)'  "$SYS_DISK")\n"
  OUTPUT+="$(row 'Bandwidth' "$SYS_BW")\n\n"

  OUTPUT+="$(header '  Network & Weather')\n"
  OUTPUT+="$(row 'WiFi'    "$NET_WIFI")\n"
  OUTPUT+="$(row 'Weather' "$NET_WX")\n\n"

  OUTPUT+="$(header '  Audio & Display')\n"
  OUTPUT+="$(row 'Volume'     "$AV_VOL")\n"
  OUTPUT+="$(row 'Brightness' "$AV_BRIGHT")\n\n"

  OUTPUT+="$(header '  System')\n"
  OUTPUT+="$(row 'Power'   "$SYS_POWER")\n"
  OUTPUT+="$(row 'Keymap'  "$SYS_KB")\n"
  OUTPUT+="$(row 'Battery' "$SYS_BATT" "#8d6e63")\n"
  OUTPUT+="$(row 'Clock'   "$SYS_TIME")\n\n"

  OUTPUT+="$(sep)\n"
  OUTPUT+="$(gum style --foreground "$CLR_SEP" --align center --width 42 'q · close dashboard')\n"

  clear
  printf "%b" "$OUTPUT"

  sleep 1
done
