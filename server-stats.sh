#!/bin/bash

echo "========================================="
echo "       SERVER PERFORMANCE REPORT"
echo "========================================="

# ---------------- CPU Usage ----------------
cpu=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
echo "CPU Usage       : $cpu%"

# --------------- Memory Usage --------------
mem=$(free -m | awk 'NR==2{printf "%sMB used / %sMB total (%.2f%%)\n", $3, $2, $3*100/$2}')
echo "Memory Usage    : $mem"

# ---------------- Disk Usage ---------------
disk=$(df --total | grep total | awk '{printf "%s used / %s total (%s used)\n", $3, $2, $5}')
echo "Disk Usage      : $disk"

# -------- Top 5 Processes by CPU ----------
echo ""
echo "Top 5 Processes by CPU Usage:"
ps -eo pid,comm,%cpu --sort=-%cpu | head -6

# -------- Top 5 Processes by Memory -------
echo ""
echo "Top 5 Processes by Memory Usage:"
ps -eo pid,comm,%mem --sort=-%mem | head -6

# --------------- Extra Info ----------------
echo ""
echo "Operating System: $(hostnamectl | grep 'Operating System' | cut -d: -f2 | xargs)"
echo "Uptime          : $(uptime -p)"
echo "Load Average    : $(uptime | awk -F'load average:' '{print $2}' | xargs)"
echo "Logged-in Users : $(who | wc -l)"

# Last 5 failed SSH login attempts (optional)
echo ""
echo "Last 5 Failed SSH Login Attempts:"
sudo journalctl -u sshd | grep "Failed password" | tail -5

echo "========================================="

