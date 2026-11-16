#!/bin/sh
# Notifies on rfkill state changes (airplane key is handled by firmware,
# no keysym reaches sxhkd). Diffs against a baseline so it only fires on
# an actual flip, not once at every startup.

is_blocked() { rfkill list | grep -q "Soft blocked: yes" && echo 1 || echo 0; }

prev="$(is_blocked)"
udevadm monitor --udev --subsystem-match=rfkill 2>/dev/null | while read -r _; do
	now="$(is_blocked)"
	[ "$now" = "$prev" ] && continue
	prev="$now"
	if [ "$now" = 1 ]; then
		dunstify -r 91191 -u low "Airplane mode" "Wireless radios blocked"
	else
		dunstify -r 91191 -u low "Airplane mode" "Wireless radios enabled"
	fi
done
