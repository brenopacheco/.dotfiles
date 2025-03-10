#!/bin/bash
# shellcheck disable=SC2012
# Called by udev rule with %p

exec 1> >(logger -p user.notice -t keyboard)
exec 2> >(logger -p user.err -t keyboard)
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus

echo "Starting configuration - $(whoami): ACTION $ACTION - HID_NAME: $HID_NAME"

ls /tmp/.X11-unix 2>/dev/null | sed 's/X//' | sort | uniq | while read -r DISPLAY; do
	export DISPLAY=":$DISPLAY"
	echo "Configuring keyboard - DISPLAY $DISPLAY"
	case "$HID_NAME" in
	"Keyboard K380")
		(
			sleep 1
			~/bin/reset-keyboard
			notify-send -i input-keyboard "$HID_NAME" "Reset"
		) &
		disown
		;;
	esac
done

echo "Configuration finished"

exit 0
