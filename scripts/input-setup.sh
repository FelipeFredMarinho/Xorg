#!/bin/sh
#
# Pointer tuning GNOME normally applies via gsettings, done explicitly here
# since bspwm doesn't touch input devices at all by default. Devices are
# matched by substring so this should still apply on another machine (e.g.
# the Arch notebook) even if the exact device string differs -- check with
# `xinput list` there if a device doesn't get picked up.

ACCEL_SPEED=0.3
# lower = more scroll per mm of finger travel (libinput default is 15)
SCROLL_PIXEL_DISTANCE=10
KEY_REPEAT_DELAY=250
KEY_REPEAT_RATE=40

xsetroot -cursor_name left_ptr

# X11 default is 660ms delay / 25cps -- noticeably sluggish holding a key down
xset r rate "$KEY_REPEAT_DELAY" "$KEY_REPEAT_RATE"

xinput list --name-only | while IFS= read -r name; do
	case "$name" in
		*[Tt]ouchpad*)
			xinput set-prop "$name" "libinput Tapping Enabled" 1 2>/dev/null
			xinput set-prop "$name" "libinput Accel Speed" "$ACCEL_SPEED" 2>/dev/null
			xinput set-prop "$name" "libinput Scrolling Pixel Distance" "$SCROLL_PIXEL_DISTANCE" 2>/dev/null
			;;
		*[Tt]rack[Pp]oint*|*[Pp]ointing*[Ss]tick*|*Mouse*)
			xinput set-prop "$name" "libinput Accel Speed" "$ACCEL_SPEED" 2>/dev/null
			;;
	esac
done
