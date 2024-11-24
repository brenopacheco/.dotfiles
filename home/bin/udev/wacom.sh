#!/bin/bash
# shellcheck disable=SC2012
# Called by udev rule with %p

exec 1> >(logger -p user.notice -t wacom)
exec 2> >(logger -p user.err -t wacom)

ls /tmp/.X11-unix 2>/dev/null | sed 's/X//' | sort | uniq | while read -r DISPLAY; do
	echo "Configuring wacom - $(whoami): DISPLAY - $DISPLAY - ACTION $ACTION - HID_NAME: $HID_NAME"
	export DISPLAY=":$DISPLAY"
	if [[ "$HID_NAME" =~ "Wacom" ]]; then
		echo "Configuring wacom - $(whoami): xsetwacom stylus"
		xsetwacom set 'Wacom One pen tablet small stylus' MapToOutput HDMI-A-0
		echo "Configuring wacom - $(whoami): xsetwacom eraser"
		xsetwacom set 'Wacom One pen tablet small eraser' MapToOutput HDMI-A-0
	else
		echo "Configuring wacom - no Wacom device"
	fi
done

exit 0
