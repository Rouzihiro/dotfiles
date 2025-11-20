#!/bin/bash

# Fetch GPU data
gpu_info=$(nvidia-smi --query-gpu=utilization.gpu,memory.used,memory.total,temperature.gpu,power.draw,power.limit --format=csv,noheader,nounits)

# Parse
IFS=',' read -r gpu_util vram_used vram_total temp power_draw power_limit <<< "$gpu_info"

# Format VRAM to GB
vram_used=$(echo "$vram_used" | awk '{printf "%.1f", $1/1024}')
vram_total=$(echo "$vram_total" | awk '{printf "%.1f", $1/1024}')

# Trim whitespace
gpu_util=$(echo "$gpu_util" | xargs)
temp=$(echo "$temp" | xargs)
power_draw=$(echo "$power_draw" | awk '{printf "%.0f", $1}')
power_limit=$(echo "$power_limit" | awk '{printf "%.0f", $1}')

# Build tooltip
tooltip="󰢮 Utilization: ${gpu_util}%\n"
tooltip+=" Temperature: ${temp}°C\n"
tooltip+="󰍛 VRAM: ${vram_used}GB / ${vram_total}GB\n"
tooltip+="󰚥 Power: ${power_draw}W / ${power_limit}W"

echo "{\"text\":\"$gpu_util%\",\"tooltip\":\"$tooltip\"}"
