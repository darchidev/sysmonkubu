#!/bin/bash
# monitor.sh - SysMonKubu data collector
# Output: CPU% GPU% RAM% DISK%

export LC_ALL=C

# CPU: calcolo corretto dell'utilizzo
idle1=$(grep '^cpu ' /proc/stat | awk '{print $5}')
total1=$(grep '^cpu ' /proc/stat | awk '{print $2+$3+$4+$5}')
sleep 0.1
idle2=$(grep '^cpu ' /proc/stat | awk '{print $5}')
total2=$(grep '^cpu ' /proc/stat | awk '{print $2+$3+$4+$5}')
idle_delta=$((idle2 - idle1))
total_delta=$((total2 - total1))
if [ $total_delta -gt 0 ]; then
    cpu=$(awk "BEGIN {printf \"%.1f\", (1 - $idle_delta / $total_delta) * 100}")
else
    cpu="0.0"
fi
echo -n "$cpu "

# GPU: NVIDIA → nvidia-smi, AMD/Intel → gpu_busy_percent (kernel)
gpu=0
if command -v nvidia-smi &>/dev/null; then
    gpu=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader 2>/dev/null | head -1 | sed 's/ //g; s/%//')
elif ls /sys/class/drm/card*/device/gpu_busy_percent &>/dev/null; then
    gpu=$(cat /sys/class/drm/card*/device/gpu_busy_percent 2>/dev/null | head -1)
fi
gpu=$(awk "BEGIN {printf \"%.1f\", $gpu + 0}")
echo -n "$gpu "

# RAM con decimale
mem=$(free -m | awk '/^Mem/{printf "%.1f", $3/$2*100}')
echo -n "$mem "

# DISCO con decimale
disk=$(df / | awk 'NR==2{printf "%.1f", $5}')
echo "$disk"