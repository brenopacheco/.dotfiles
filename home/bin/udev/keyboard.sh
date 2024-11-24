#!/bin/bash
# shellcheck disable=SC2012
# Called by udev rule with %p

exec 1> >(logger -p user.notice -t keyboard)
exec 2> >(logger -p user.err -t keyboard)

ls /tmp/.X11-unix 2>/dev/null | sed 's/X//' | sort | uniq | while read -r DISPLAY; do
	echo "Configuring keyboard - $(whoami): DISPLAY - $DISPLAY - ACTION $ACTION - HID_NAME: $HID_NAME"
	export DISPLAY=":$DISPLAY"
	case "$HID_NAME" in
	"Keyboard K380")
		~/bin/reset_keyboard
		;;
	esac
done

exit 0
