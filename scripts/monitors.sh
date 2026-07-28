#!/usr/bin/env sh
#
# Applies xrandr layout, the bspwm desktop split, and the polybar instance
# count together, keyed off whether the external is connected -- single
# source of truth so all three can't drift out of sync. Called from
# bspwmrc at startup, from super+shift+m in sxhkdrc, and automatically by
# scripts/monitor-watch.sh whenever the external is plugged/unplugged.
#
#   - laptop panel: 1920x1200 16:10 @60Hz (always present)
#   - external:     2560x1080 21:9 @75Hz (only when connected), positioned
#                   to the left of the laptop panel
#
# IMPORTANT: output names below (eDP-1 / DP-1) are the common ThinkPad/Intel
# defaults but are NOT guaranteed on your hardware. Confirm with:
#   xrandr --query
# and edit LAPTOP / EXTERNAL below to match what you see there
# (e.g. eDP-1, eDP, HDMI-1, DP-2-1, DP-2-2 are all common variants).

LAPTOP="eDP-1"
EXTERNAL="DP-1"

if xrandr --query | grep -q "^${EXTERNAL} connected"; then
	xrandr \
		--output "$LAPTOP"   --primary --mode 1920x1200 --rate 60 --pos 0x0 \
		--output "$EXTERNAL" --mode 2560x1080 --rate 75 --left-of "$LAPTOP"

	bspc monitor "$EXTERNAL" -d 1 2 3 4 5
	bspc monitor "$LAPTOP" -d 6 7 8 9 10

	killall -q polybar
	MONITOR="$LAPTOP" polybar mainbar &
	MONITOR="$EXTERNAL" polybar mainbar &
else
	# laptop only
	xrandr --output "$LAPTOP" --primary --mode 1920x1200 --rate 60 \
		--output "$EXTERNAL" --off

	bspc monitor "$LAPTOP" -d 1 2 3 4 5 6 7 8 9 10

	killall -q polybar
	MONITOR="$LAPTOP" polybar mainbar &
fi

bspc wm --reorder-monitor

