#!/usr/bin/env sh

#polybar-msg cmd quit
#polybar mybar
#
#echo "Bars launched..."
# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

polybar mybar
# for multimonitor
if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload example & disown
  done
else
  polybar --reload example & disown
fi
