#!/bin/sh
# Called by udev rule with %p

exec 1> >(logger -p user.notice -t keyboard)
exec 2> >(logger -p user.err -t keyboard)

echo "Run by $(whoami): - ACTION $ACTION - HID_NAME: $HID_NAME"

case "$HID_NAME" in
	"Keyboard K380")
                setxkbmap -model pc105 -layout gb
                xmodmap ~/.Xmodmap
		;;
	"Adv360 Pro")
                setxkbmap -model pc104 -layout us
		;;
esac
