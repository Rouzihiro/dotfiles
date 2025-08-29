#!/usr/bin/bash

# pick your interface (use ip link to check)
NET_IF="wlp1s0"

# initial rx bytes
prev_rx=$(cat /sys/class/net/$NET_IF/statistics/rx_bytes)

while true; do
  Vol=" $(pamixer --get-volume-human)"
  Bat=" $(cat /sys/class/power_supply/BAT1/capacity)%"
  Day=" $(date '+%a,%Y-%m-%d')"
  Time=" $(date '+%I:%M %p')"
#  Music=" $(playerctl metadata --format "{{ artist }} - {{ title }}" | awk '{print substr($0, 1, 32)}')"
  Bklit="󰃟 $(brightnessctl i | awk '/Current brightness/ {print $4}' | sed 's/[()]//g')"

  # Memory usage (MiB)
  mem_used=$(awk '/MemTotal/ {total=$2} /MemAvailable/ {avail=$2} END {printf "%dMiB", (total-avail)/1024}' /proc/meminfo)
  Mem=" $mem_used"

  # CPU temperature (first core/package)
  cpu_temp=$(sensors | awk '/Package id 0:/ {print $4; exit}')
  Cpu=" $cpu_temp"

  # Disk free space (/)
  disk_free=$(df -h / | awk 'NR==2 {print $4}')
  Disk="󰋊 $disk_free"

  # Network download rate (MB/s)
  rx_now=$(cat /sys/class/net/$NET_IF/statistics/rx_bytes)
  rx_rate=$(echo "scale=1; ($rx_now - $prev_rx)/1024/1024" | bc)
  Net="󰀂 ${rx_rate}MB/s"
  prev_rx=$rx_now

 # xsetroot -name "$Music | $Vol | $Mem | $Cpu | $Net | $Disk | $Bklit | $Day | $Time | $Bat"
  xsetroot -name "$Vol | $Mem | $Cpu | $Net | $Disk | $Bklit | $Day | $Time | $Bat"
	sleep 1
done
