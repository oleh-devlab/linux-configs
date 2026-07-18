#!/bin/bash

output=""
for bat in BAT0 BAT1; do
    if [ -f "/sys/class/power_supply/$bat/temp" ]; then
        t=$(cat "/sys/class/power_supply/$bat/temp" 2>/dev/null || echo "0")
        if [ "$t" -ne 0 ]; then
            val=$(awk -v t="$t" 'BEGIN { printf "%.0f°C", t/10 }')
            output="$output $bat: $val "
        fi
    fi
done

# path to temp is different
if [ -z "$output" ]; then
    file=$(grep -l 'SEN2' /sys/class/thermal/thermal_zone*/type 2>/dev/null | sed 's/type/temp/')
    if [ -n "$file" ]; then
        val=$(cat "$file" 2>/dev/null | awk '{printf "%.0f°C", $1/1000}')
        output="Temp: $val "
    fi
fi

echo "<txt>${output}</txt>"
