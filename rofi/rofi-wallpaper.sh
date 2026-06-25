#!/usr/bin/env bash

WALL_DIR="$HOME/Pictures/Background"
CACHE_DIR="$HOME/.cache/rofi-wallpaper"

mkdir -p "$CACHE_DIR"
cd "$WALL_DIR" || exit 1

VALID_EXTS=("jpg" "jpeg" "png" "webp" "bmp" "JPG" "JPEG" "PNG" "WEBP")
ROFI_OPTIONS=""

for cached_thumb in "$CACHE_DIR"/*; do
    [ -e "$cached_thumb" ] || continue
    base_name=$(basename "$cached_thumb")
    found=0
    for ext in "${VALID_EXTS[@]}"; do
        if [ -f "$WALL_DIR/${base_name%.*}.$ext" ]; then
            found=1
            break
        fi
    done
    if [ $found -eq 0 ]; then
        rm "$cached_thumb"
    fi
done

for ext in "${VALID_EXTS[@]}"; do
    for img in *."$ext"; do
        [[ -e "$img" ]] || continue
        
        thumb="$CACHE_DIR/${img%.*}.png"
        
        if [ ! -f "$thumb" ] || [ "$img" -nt "$thumb" ]; then
            convert "$img" -thumbnail 200x200^ -gravity center -extent 200x200 "$thumb" 2>/dev/null || cp "$img" "$thumb"
        fi
        
        ROFI_OPTIONS+="${img}\0icon\x1f${thumb}\n"
    done
done

SELECTION=$(echo -e -n "$ROFI_OPTIONS" | rofi -dmenu -i \
    -p "🌌 Wallpapers" \
    -theme-str 'window { width: 60%; height: 70%; } listview { columns: 4; lines: 3; spacing: 15px; } element { orientation: vertical; padding: 12px; } element-icon { size: 110px; horizontal-align: 0.5; } element-text { horizontal-align: 0.5; }')

if [ -n "$SELECTION" ]; then
    FULL_PATH="$WALL_DIR/$SELECTION"
    
    feh --bg-fill "$FULL_PATH"
    
    echo "$FULL_PATH" > "$HOME/.current_wallpaper"
    
    notify-send "Wallappers changed" "Set up: $SELECTION" --icon="$CACHE_DIR/${SELECTION%.*}.png" -a "System"
fi
