#!/bin/sh
# Polybar power-button menu.
choice=$(printf 'Lock\nSuspend\nReboot\nPoweroff\nCancel' | rofi -dmenu -p 'Power')
case "$choice" in
	Lock) ~/.config/Xorg/scripts/lock.sh ;;
	Suspend) ~/.config/Xorg/scripts/lock.sh & systemctl suspend ;;
	Reboot) systemctl reboot ;;
	Poweroff) systemctl poweroff ;;
esac
