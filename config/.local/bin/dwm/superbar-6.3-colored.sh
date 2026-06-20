#!/usr/bin/bash

# pick your interface (use ip link to check)
NET_IF="wlan0"

# initial rx bytes
prev_rx=$(cat /sys/class/net/$NET_IF/statistics/rx_bytes)

while true; do
  # Kanagawa colors
  FG="#dcd7ba"    # default foreground
  VOL="#7e9cd8"   # blue
  BAT="#98bb6c"   # green
  DAY="#e6c384"   # yellow
  TIME="#957fb8"  # purple
  MUS="#c8a6ff"   # violet
  BKLIT="#ffa066" # orange
  MEM="#7fb4ca"   # teal
  CPU="#c34043"   # red
  NET="#7aa89f"   # green-cyan
  DISK="#6a9589"  # grey-cyan

  Vol="^c${VOL}^ ^c${FG}^$(pamixer --get-volume-human)"
  Bat="^c${BAT}^ ^c${FG}^$(cat /sys/class/power_supply/macsmc-battery/capacity)%"
  Day="^c${DAY}^ ^c${FG}^$(date '+%a,%Y-%m-%d')"
  Time="^c${TIME}^ ^c${FG}^$(date '+%I:%M %p')"
  Music=" ^c${MUS}^ ^c${FG}^$(playerctl metadata --format "{{ artist }} - {{ title }}" | awk '{print substr($0, 1, 32)}')"
  Bklit="^c${BKLIT}^󰃟 ^c${FG}^$(brightnessctl i | awk '/Current brightness/ {print $4}' | sed 's/[()]//g')"

  # Memory usage (MiB)
  mem_used=$(awk '/MemTotal/ {total=$2} /MemAvailable/ {avail=$2} END {printf "%dMiB", (total-avail)/1024}' /proc/meminfo)
  Mem="^c${MEM}^ ^c${FG}^$mem_used"

  # CPU temperature (first core/package)
  cpu_temp=$(sensors | awk '/Package id 0:/ {print $4; exit}')
  Cpu="^c${CPU}^ ^c${FG}^$cpu_temp"

  # Disk free space (/)
  disk_free=$(df -h / | awk 'NR==2 {print $4}')
  Disk="^c${DISK}^󰋊 ^c${FG}^$disk_free"

  # Network download rate (MB/s)
  rx_now=$(cat /sys/class/net/$NET_IF/statistics/rx_bytes)
  rx_rate=$(echo "scale=1; ($rx_now - $prev_rx)/1024/1024" | bc)
  Net="^c${NET}^󰀂 ^c${FG}^${rx_rate}MB/s"
  prev_rx=$rx_now

  xsetroot -name "$Music | $Vol | $Mem | $Cpu | $Net | $Disk | $Bklit | $Day | $Time | $Bat"
  sleep 1
done
