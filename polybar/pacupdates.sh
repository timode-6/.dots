#!/bin/bash

green="#53E8D4"    
yellow="#FFFDBB"
red="#A54242"

if updates=$(checkupdates --nocolor 2>/dev/null); then
    count=$(echo "$updates" | sed '/^\s*$/d' | wc -l)
    
    if [ "$count" -eq 0 ]; then
        color="$green"
    elif [ "$count" -le 10 ]; then
        color="$yellow"
    else
        color="$red"
    fi
    echo -e " Up: $count"
else
    echo -e " Up: Offline" 
fi
