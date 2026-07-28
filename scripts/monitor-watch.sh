#!/usr/bin/env sh
#
# Watches for the external monitor being plugged/unplugged and re-runs
# monitors.sh automatically, instead of requiring the super+shift+m hotkey
# after every hotplug. Debounced against the connected/disconnected state
# actually changing, since a single physical hotplug can fire several DRM
# uevents and monitors.sh (xrandr + bspc + polybar) isn't cheap to rerun
# for no reason.

EXTERNAL="DP-1"

is_connected() {
	xrandr --query | grep -q "^${EXTERNAL} connected" && echo 1 || echo 0
}

prev="$(is_connected)"

udevadm monitor --udev --subsystem-match=drm 2>/dev/null | while read -r _; do
	# give the kernel/EDID a moment to settle before checking
	sleep 1
	now="$(is_connected)"
	[ "$now" = "$prev" ] && continue
	prev="$now"
	~/.config/Xorg/scripts/monitors.sh
done
