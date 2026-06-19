#!/bin/bash

# M1 Mac System Info Fetcher for Asahi Linux
# Fetches CPU, GPU, memory, and thermal information

get_cpu_info() {
    # CPU usage (average of all cores) - Linux top version
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}' | awk '{printf "%.0f", $1}')
    cpu_temp=$(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null | awk '{printf "%.1f", $1/1000}' || echo "N/A")
    cpu_freq=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq 2>/dev/null | awk '{printf "%.1f", $1/1000000}' || echo "N/A")
    
    echo "$cpu_usage,$cpu_temp,$cpu_freq"
}

get_gpu_info() {
    # GPU usage - try different possible locations
    gpu_usage=$(cat /sys/class/drm/card0/device/gpu_busy_percent 2>/dev/null || \
                cat /sys/class/drm/card1/device/gpu_busy_percent 2>/dev/null || echo "0")
    
    gpu_freq=$(cat /sys/class/drm/card0/device/cur_freq 2>/dev/null | awk '{printf "%.1f", $1/1000000}' || \
               cat /sys/class/drm/card1/device/cur_freq 2>/dev/null | awk '{printf "%.1f", $1/1000000}' || echo "")
    
    echo "$gpu_usage,$gpu_freq"
}

get_memory_info() {
    # Memory usage
    mem_total=$(free -g | grep Mem: | awk '{print $2}')
    mem_used=$(free -g | grep Mem: | awk '{print $3}')
    mem_available=$(free -g | grep Mem: | awk '{print $7}')
    swap_used=$(free -g | grep Swap: | awk '{print $3}')
    
    echo "$mem_used,$mem_total,$mem_available,$swap_used"
}

get_power_info() {
    # Battery/power information
    battery=$(cat /sys/class/power_supply/macsmc-battery/capacity 2>/dev/null || \
              cat /sys/class/power_supply/*battery*/capacity 2>/dev/null | head -1 || echo "0")
    
    # Fix negative power reading
    power_draw=$(cat /sys/class/hwmon/hwmon*/power1_input 2>/dev/null | head -1 | awk '{p=$1/1000000; if(p<0) p=-p; printf "%.1f", p}' || echo "N/A")
    
    echo "$battery,$power_draw"
}

get_thermal_info() {
    # Additional thermal sensors - only include if they exist and have valid data
    soc_temp=""
    big_temp=""
    
    # Check if thermal zones exist and have non-zero values
    if [ -f /sys/class/thermal/thermal_zone1/temp ]; then
        temp_val=$(cat /sys/class/thermal/thermal_zone1/temp)
        if [ "$temp_val" -gt 0 ]; then
            soc_temp=$(echo "$temp_val" | awk '{printf "%.1f", $1/1000}')
        fi
    fi
    
    if [ -f /sys/class/thermal/thermal_zone2/temp ]; then
        temp_val=$(cat /sys/class/thermal/thermal_zone2/temp)
        if [ "$temp_val" -gt 0 ]; then
            big_temp=$(echo "$temp_val" | awk '{printf "%.1f", $1/1000}')
        fi
    fi
    
    echo "$soc_temp,$big_temp"
}

# Fetch all data
cpu_data=$(get_cpu_info)
gpu_data=$(get_gpu_info)
mem_data=$(get_memory_info)
power_data=$(get_power_info)
thermal_data=$(get_thermal_info)

# Parse CPU data
IFS=',' read -r cpu_usage cpu_temp cpu_freq <<< "$cpu_data"

# Parse GPU data  
IFS=',' read -r gpu_usage gpu_freq <<< "$gpu_data"

# Parse Memory data
IFS=',' read -r mem_used mem_total mem_available swap_used <<< "$mem_data"

# Parse Power data
IFS=',' read -r battery power_draw <<< "$power_data"

# Parse Thermal data
IFS=',' read -r soc_temp big_temp <<< "$thermal_data"

# Build main display text (CPU usage as primary indicator)
text="${cpu_usage}%"

# Build detailed tooltip
tooltip=" CPU: ${cpu_usage}%"
if [ "$cpu_freq" != "N/A" ]; then
    tooltip+=" (${cpu_freq}GHz)"
fi

if [ "$cpu_temp" != "N/A" ]; then
    tooltip+="\n󰾅 Temp: ${cpu_temp}°C"
fi

# Only show GPU if we have valid data
if [ "$gpu_usage" != "0" ] || [ -n "$gpu_freq" ]; then
    tooltip+="\n󰢮 GPU: ${gpu_usage}%"
    if [ -n "$gpu_freq" ] && [ "$gpu_freq" != "0.0" ]; then
        tooltip+=" (${gpu_freq}GHz)"
    fi
fi

tooltip+="\n󰍛 RAM: ${mem_used}GB / ${mem_total}GB"
tooltip+="\n󰾆 Available: ${mem_available}GB"

if [ "$swap_used" -gt 0 ]; then
    tooltip+="\n󰓅 Swap: ${swap_used}GB"
fi

if [ "$battery" != "0" ]; then
    tooltip+="\n󱊣 Battery: ${battery}%"
fi

if [ "$power_draw" != "N/A" ]; then
    tooltip+="\n󰂑 Power: ${power_draw}W"
fi

if [ -n "$soc_temp" ]; then
    tooltip+="\n󰔏 SoC Temp: ${soc_temp}°C"
fi

if [ -n "$big_temp" ]; then
    tooltip+="\n Big Core: ${big_temp}°C"
fi

# Output in JSON format for status bars
echo "{\"text\":\"$text\",\"tooltip\":\"$tooltip\"}"
