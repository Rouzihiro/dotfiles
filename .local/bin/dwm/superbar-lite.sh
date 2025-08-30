#!/usr/bin/bash

# pick your interface (use ip link to check)
NET_IF="wlan0"

# initial rx bytes
prev_rx=$(cat /sys/class/net/$NET_IF/statistics/rx_bytes)

while true; do
  Vol=" $(pamixer --get-volume-human)"
  Bat=" $(cat /sys/class/power_supply/macsmc-battery/capacity)%"
 # Day=" $(date '+%a,%Y-%m-%d')"
  Time=" $(date '+%I:%M %p')"
  Music=" $(playerctl metadata --format "{{ artist }} - {{ title }}" | awk '{print substr($0, 1, 32)}')"
  Bklit="󰃟 $(brightnessctl i | awk '/Current brightness/ {print $4}' | sed 's/[()]//g')"

  # Memory usage (MiB)
  mem_used=$(awk '/MemTotal/ {total=$2} /MemAvailable/ {avail=$2} END {printf "%dMiB", (total-avail)/1024}' /proc/meminfo)
  Mem=" $mem_used"

  # CPU temperature (first core/package)
	temps=$(sensors | awk '/Temp|Temperature|Hotspot/ {gsub(/\+|°C/,"",$3); print $3}')
	max_temp=$(echo "$temps" | sort -nr | head -n1)
	Cpu=" ${max_temp}°C"

  # Disk free space (/)
  disk_free=$(df -h / | awk 'NR==2 {print $4}')
  Disk="󰋊 $disk_free"

  # Network download rate (MB/s)
  rx_now=$(cat /sys/class/net/$NET_IF/statistics/rx_bytes)
  rx_rate=$(echo "scale=1; ($rx_now - $prev_rx)/1024/1024" | bc)
  Net="󰀂 ${rx_rate}MB/s"
  prev_rx=$rx_now

  xsetroot -name "$Music | $Vol | $Mem | $Cpu | $Net | $Disk | $Bklit | $Time | $Bat"
  sleep 1
done
