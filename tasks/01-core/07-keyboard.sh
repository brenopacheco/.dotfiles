#!/usr/bin/env bash

function should_run() {
	test -e /etc/udev/rules.d/50-keyboard.rules &&
		test -e /opt/bin/keyboard.sh &&
		return "$DONE" || return "$RUN"
}

function task() {
	echo "$RULE" | sudo tee /etc/udev/rules.d/50-keyboard.rules &&
		sudo mkdir -p /opt/bin &&
		sudo cp "$KEYBOARD_SH" /opt/bin/keyboard.sh &&
		sudo chown breno:breno /opt/bin/keyboard.sh &&
		sudo chmod +x /opt/bin/keyboard.sh &&
		return "$OK"
}

# Display depends on which HDMI port we are using
RULE='ACTION=="bind", SUBSYSTEM=="hid", RUN+="/usr/bin/su breno -c /opt/bin/keyboard.sh %p"'

KEYBOARD_SH=$(mktemp)

cat >"$KEYBOARD_SH" <<'EOF'
#!/bin/sh
# Called by udev rule with %p

exec 1> >(logger -p user.notice -t keyboard)
exec 2> >(logger -p user.err -t keyboard)

ls /tmp/.X11-unix 2>/dev/null | sed 's/X//' | sort | uniq | while read -r DISPLAY; do
	echo "Configuring keyboard - $(whoami): DISPLAY - $DISPLAY - ACTION $ACTION - HID_NAME: $HID_NAME"
	export DISPLAY=":$DISPLAY"
	case "$HID_NAME" in
	"Keyboard K380")
		setxkbmap -model ppc105+inet -layout us
		xmodmap "$HOME/.Xmodmap"
		;;
	esac
done

exit 0
EOF

