#!/bin/bash
# shellcheck disable=SC2012
# Called by udev rule with %p

exec 1> >(logger -p user.notice -t keyboard)
exec 2> >(logger -p user.err -t keyboard)

echo "Starting configuration - $(whoami): ACTION $ACTION - HID_NAME: $HID_NAME"

ls /tmp/.X11-unix 2>/dev/null | sed 's/X//' | sort | uniq | while read -r DISPLAY; do
	export DISPLAY=":$DISPLAY"
	echo "Configuring keyboard - DISPLAY $DISPLAY"
	case "$HID_NAME" in
	"Keyboard K380")
		setxkbmap -model ppc105+inet -layout us
		xrdb ~/.Xresources
		xmodmap ~/.Xmodmap
		xset r rate 200 30
		;;
	esac
done

echo "Configuration finished"

exit 0
