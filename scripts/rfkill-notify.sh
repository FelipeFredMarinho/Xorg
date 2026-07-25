#!/bin/sh
#
# The airplane-mode key is handled entirely by the ThinkPad's firmware --
# no XF86 keysym for it ever reaches X11/sxhkd, which is why it works with
# no keybind anywhere in this repo. This just watches udev for the rfkill
# state flip so a notification can show up when it happens.

udevadm monitor --udev --subsystem-match=rfkill 2>/dev/null | while read -r _; do
	if rfkill list | grep -q "Soft blocked: yes"; then
		dunstify -r 91191 -u low "Airplane mode" "Wireless radios blocked"
	else
		dunstify -r 91191 -u low "Airplane mode" "Wireless radios enabled"
	fi
done
