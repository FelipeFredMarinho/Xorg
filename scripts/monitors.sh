#!/bin/sh
#
# Applies monitor layout:
#   - laptop panel: 1920x1200 16:10 @60Hz (always present)
#   - external:     2560x1080 21:9 @60Hz (only when connected)
#
# IMPORTANT: output names below (eDP-1 / DP-1) are the common ThinkPad/Intel
# defaults but are NOT guaranteed on your hardware. Confirm with:
#   xrandr --query
# and edit LAPTOP / EXTERNAL below to match what you see there
# (e.g. eDP-1, eDP, HDMI-1, DP-2-1, DP-2-2 are all common variants).

LAPTOP="eDP-1"
EXTERNAL="HDMI-1"

if xrandr --query | grep -q "^${EXTERNAL} connected"; then
	# external present: laptop on the left, ultrawide extending to the right
	xrandr \
		--output "$LAPTOP"   --primary --mode 1920x1200 --rate 60 --pos 0x0 \
		--output "$EXTERNAL" --mode 2560x1080 --rate 60 --pos 1920x0
else
	# laptop only
	xrandr --output "$LAPTOP" --primary --mode 1920x1200 --rate 60 \
		--output "$EXTERNAL" --off
fi

