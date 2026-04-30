#!/bin/bash
# monitor.sh - SysMonKubu data collector
# Output: CPU% GPU% RAM% DISK%

# CPU: delta da /proc/stat
c1=$(grep -E '^Cpu[0-9] ' /proc/stat | awk '{user=$2; nice=$3; sys=$4; idle=$5; print user+sys+nice+idle}')
sleep 0.1
c2=$(grep -E '^Cpu[0-9] ' /proc/stat | awk '{user=$2; nice=$3; sys=$4; idle=$5; print user+sys+nice+idle}')
cpu=$(( (c2 - c1) * 100 / (c2 - c1 + 1) ))
echo -n "$cpu "

# GPU: NVIDIA → nvidia-smi, AMD/Intel → gpu_busy_percent (kernel)
gpu=0
if command -v nvidia-smi &>/dev/null; then
    gpu=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader 2>/dev/null | head -1 | sed 's/ //g; s/%//')
elif ls /sys/class/drm/card*/device/gpu_busy_percent &>/dev/null; then
    gpu=$(cat /sys/class/drm/card*/device/gpu_busy_percent 2>/dev/null | head -1)
fi
echo -n "${gpu:-0} "

# RAM
mem=$(free -m | awk '/^Mem/{printf "%.0f", $3/$2*100}')
echo -n "$mem "

# DISCO
disk=$(df / | awk 'NR==2{printf "%.0f", $5}')
echo "$disk"