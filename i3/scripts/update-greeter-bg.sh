#!/usr/bin/env bash
set -euo pipefail

command -v magick >/dev/null 2>&1 && IM=(magick) || IM=(convert)

WALLPAPER="$(cat "$HOME/.current_wallpaper" 2>/dev/null || echo "$HOME/.config/i3/wallpaper.jpg")"
OUT="/var/cache/greeter-bg/current.png"
RES="$(xrandr --current | grep '\*' | head -1 | awk '{print $1}')"
BLUR="0x8"

[ -f "$WALLPAPER" ] || exit 0

"${IM[@]}" "$WALLPAPER" -resize "${RES}^" -gravity center -extent "$RES" \
    -blur "$BLUR" "$OUT"
chmod 644 "$OUT"