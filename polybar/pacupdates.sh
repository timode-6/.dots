#!/bin/bash

green="#53E8D4"    
yellow="#FFFDBB"
red="#A54242"

# Get the number of available updates
updates=$(checkupdates --nocolor | wc -l)

# Determine the color based on the number of updates
if [ "$updates" -eq 0 ]; then
    color="$green"
elif [ "$updates" -le 10 ]; then
    color="$yellow"
else
    color="$red"
fi

# Output the result in Polybar format with the selected color
echo -e " Up: $updates"