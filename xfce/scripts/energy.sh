#!/bin/bash

output=""
for bat in BAT0 BAT1; do
    if [ -d "/sys/class/power_supply/$bat" ]; then
        p=$(cat "/sys/class/power_supply/$bat/power_now" 2>/dev/null || echo "0")
        v=$(cat "/sys/class/power_supply/$bat/voltage_now" 2>/dev/null || echo "0")
        
        if [ "$p" -ne 0 ] || [ "$v" -ne 0 ]; then
            val=$(awk -v p="$p" -v v="$v" 'BEGIN { printf "%.2fW | %.1fV", p/1000000, v/1000000 }')
            output="$output $bat: $val "
        fi
    fi
done

echo "<txt>${output} ⚡</txt>"
