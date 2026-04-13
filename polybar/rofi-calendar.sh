#!/bin/bash

# Build a simple month view using cal
CALENDAR=$(cal --color=never)
MONTH_YEAR=$(date "+%B %Y")

echo "$CALENDAR" | rofi \
    -dmenu \
    -p "󱑂  $MONTH_YEAR" \
    -no-fixed-num-lines \
    -width 220 \
    -theme-str '
        window { width: 300px; height: 400px; }
        listview { lines: 9; }
        entry { enabled: false; }
    '