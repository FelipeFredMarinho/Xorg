#!/bin/sh
# Clickable notification history for polybar. Not identical to Ubuntu's
# panel (dunst has no persistent list view) -- lists past notifications
# via rofi, selecting one re-displays it via dunstctl history-pop <ID>.

sel=$(dunstctl history | jq -r '.data[0][] | "\(.id.data): \(.summary.data)"' | rofi -dmenu -p "Notifications")
[ -n "$sel" ] || exit 0
dunstctl history-pop "${sel%%:*}"