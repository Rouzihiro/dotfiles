#!/bin/bash

# M1 Mac System Monitor for Asahi Linux
# Clean version without GPU monitoring

# CPU usage
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}' | awk '{printf "%.0f", $1}')
cpu_freq=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq 2>/dev/null | awk '{printf "%.1f", $1/1000000}' || echo "")

# Temperature
cpu_temp=$(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null | awk '{printf "%.1f", $1/1000}')

# Memory
mem_used=$(free -g | grep Mem: | awk '{print $3}')
mem_total=$(free -g | grep Mem: | awk '{print $2}')
mem_available=$(free -g | grep Mem: | awk '{print $7}')

# Battery
battery=$(cat /sys/class/power_supply/macsmc-battery/capacity 2>/dev/null)

# Power
power_draw=$(cat /sys/class/hwmon/hwmon*/power1_input 2>/dev/null | head -1 | awk '{p=$1/1000000; if(p<0) p=-p; printf "%.1f", p}')

# Build tooltip
tooltip=" CPU: ${cpu_usage}%"
if [ -n "$cpu_freq" ]; then
    tooltip+=" (${cpu_freq}GHz)"
fi

if [ -n "$cpu_temp" ]; then
    tooltip+="\n󰾅 Temp: ${cpu_temp}°C"
fi

tooltip+="\n󰍛 RAM: ${mem_used}GB / ${mem_total}GB"
tooltip+="\n󰾆 Available: ${mem_available}GB"

if [ -n "$battery" ]; then
    tooltip+="\n󱊣 Battery: ${battery}%"
fi

if [ -n "$power_draw" ]; then
    tooltip+="\n󰂑 Power: ${power_draw}W"
fi

echo "{\"text\":\"${cpu_usage}%\",\"tooltip\":\"$tooltip\"}"
