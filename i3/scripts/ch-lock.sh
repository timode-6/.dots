#!/usr/bin/env bash

set -euo pipefail

if command -v magick >/dev/null 2>&1; then
    IM_CONVERT=(magick)
else
    IM_CONVERT=(convert)
fi

WALLPAPER="$(cat "$HOME/.current_wallpaper" 2>/dev/null || echo "$HOME/.config/i3/wallpaper.jpg")"
AVATAR="$HOME/Pictures/Photos/me.jpg"       
NAME="Timo"

BG_IMG="/tmp/ch-lock-buzz-bg.png"
AVATAR_IMG="/tmp/ch-lock-buzz-avatar.png"
BLUR="0x8"
AVATAR_SIZE=180

BUZZLOCKER_BIN="$HOME/.config/buzzlocker/build/auth_buzzlocker"

RES="$(xrandr --current | grep '*' | head -1 | awk '{print $1}')"

"${IM_CONVERT[@]}" "$WALLPAPER" -resize "${RES}^" -gravity center -extent "$RES" \
    -blur "$BLUR" "$BG_IMG"

if [ -n "$AVATAR" ] && [ -f "$AVATAR" ]; then
    "${IM_CONVERT[@]}" "$AVATAR" -resize "${AVATAR_SIZE}x${AVATAR_SIZE}^" \
        -gravity center -extent "${AVATAR_SIZE}x${AVATAR_SIZE}" \
        \( +clone -alpha extract -fill black -colorize 100% \
           -fill white -draw "circle $((AVATAR_SIZE/2)),$((AVATAR_SIZE/2)) $((AVATAR_SIZE/2)),0" \) \
        -alpha off -compose CopyOpacity -composite "$AVATAR_IMG"
fi

if [ ! -x "$BUZZLOCKER_BIN" ]; then
    echo "auth_buzzlocker not found or not executable at: $BUZZLOCKER_BIN" >&2
    echo "Build it first: cd ~/.config/buzzlocker && ninja -C build" >&2
    exit 1
fi

export XSECURELOCK_AUTH="$BUZZLOCKER_BIN"
export XSECURELOCK_SAVER=saver_blank
export BUZZLOCKER_BG_IMAGE="$BG_IMG"
export BUZZLOCKER_AVATAR_IMAGE="$AVATAR_IMG"
export BUZZLOCKER_NAME="$NAME"
export BUZZLOCKER_ENABLE_CLOCK=1
export XSECURELOCK_COMPOSITE_OBSCURER=0

xsecurelock