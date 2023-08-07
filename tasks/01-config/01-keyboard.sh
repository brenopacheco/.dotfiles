#!/usr/bin/env bash

function should_run() {
	test -e /etc/udev/rules.d/50-keyboard.rules &&
		test -e /opt/bin/keyboard.sh &&
		return "$DONE" || return "$RUN"
}

function task() {
	echo "$RULE" | sudo tee /etc/udev/rules.d/50-keyboard.rules &&
		sudo mkdir -p /opt/bin &&
		echo "$KEYBOARD_SH" | sudo tee /opt/bin/keyboard.sh &&
		sudo chmod +x /opt/bin/keyboard.sh &&
		return "$OK"
}

RULE='ACTION=="bind", SUBSYSTEM=="hid", ENV{DISPLAY}=":0", RUN+="/usr/bin/su breno -c /opt/bin/keyboard.sh %p"'

KEYBOARD_SH=$(mktemp)

cat <<EOF >"$KEYBOARD_SH"
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
EOF
