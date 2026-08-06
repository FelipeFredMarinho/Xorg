#!/bin/sh
# Polybar power-button menu.
choice=$(printf 'Lock\nSuspend\nReboot\nPoweroff\nCancel' | rofi -dmenu -p 'Power')
case "$choice" in
	Lock) betterlockscreen -l ;;
	Suspend) betterlockscreen -l & systemctl suspend ;;
	Reboot) systemctl reboot ;;
	Poweroff) systemctl poweroff ;;
esac
