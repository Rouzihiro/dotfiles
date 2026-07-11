#!/bin/sh

MEM=$(free -m | awk '/Mem:/ {print $3}')
MEM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')

DISK=$(df -h / | awk 'NR==2 {print $5}')

UPTIME=$(uptime -p)

CPU=$(top -bn1 | awk '/Cpu/ {print 100-$8}' | cut -d. -f1)


cat > data/system.json <<EOF
{
    "cpu": "${CPU}%",
    "ram": "${MEM}MB / ${MEM_TOTAL}MB",
    "disk": "${DISK}",
    "uptime": "${UPTIME}"
}
EOF
