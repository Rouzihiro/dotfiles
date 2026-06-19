
#!/bin/bash

# Get all relevant temperatures from macsmc sensors
temps=$(sensors | awk '/Temp|Temperature|Hotspot/ {gsub(/\+|°C/,"",$3); print $3}')

# Find the maximum temperature
max_temp=$(echo "$temps" | sort -nr | head -n1)

# Format for display
Cpu=" ${max_temp}°C"

echo "$Cpu"
