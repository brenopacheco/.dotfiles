#!/usr/bin/env bash

WACOM_SCRIPT="/opt/bin/wacom.sh"
UDEV_RULE="/etc/udev/rules.d/99-wacom.rules"

function should_run() {
	test -e "$UDEV_RULE" &&
		test -e "$WACOM_SCRIPT" &&
		return "$DONE" || return "$RUN"
}

function task() {
	echo "$RULE" | sudo tee /etc/udev/rules.d/99-wacom.rules &&
		sudo mkdir -p /opt/bin &&
		sudo cp "$WACOM_SH" "$WACOM_SCRIPT" &&
		sudo chown breno:breno "$WACOM_SCRIPT" &&
		sudo chmod +x "$WACOM_SCRIPT" &&
		return "$OK"
}

# Display depends on which HDMI port we are using
RULE='ACTION=="bind", SUBSYSTEM=="hid", RUN+="/usr/bin/su breno -c /opt/bin/wacom.sh %p"'

WACOM_SH=$(mktemp)

cat >"$WACOM_SH" <<'EOF'
#!/bin/bash
# Called by udev rule with %p

exec 1> >(logger -p user.notice -t wacom)
exec 2> >(logger -p user.err -t wacom)

ls /tmp/.X11-unix 2>/dev/null | sed 's/X//' | sort | uniq | while read -r DISPLAY; do
	echo "Configuring wacom - $(whoami): DISPLAY - $DISPLAY - ACTION $ACTION - HID_NAME: $HID_NAME"
	export DISPLAY=":$DISPLAY"
	if [[ "$HID_NAME" =~ "Wacom" ]]; then
		echo "Configuring wacom - $(whoami): xsetwacom stylus"
		xsetwacom set 'Wacom One pen tablet small stylus' MapToOutput HDMI-A-0
		xsetwacom set 'Wacom One pen tablet small stylus' Button 2 "button 3"
		echo "Configuring wacom - $(whoami): xsetwacom eraser"
		xsetwacom set 'Wacom One pen tablet small eraser' MapToOutput HDMI-A-0
	else
		echo "Configuring wacom - no Wacom device"
	fi
done

exit 0
EOF
