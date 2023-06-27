#!/usr/bin/env bash

CONFIG=$(
	cat <<'EOF'
Section "InputClass"
    Identifier "touchpad"
    Driver "libinput"
    MatchIsTouchpad "on"
    Option "Tapping" "on"
    Option "TappingButtonMap" "lmr"
EndSection
EOF
)

function should_run() {
	test -e /etc/X11/xorg.conf.d/30-touchpad.conf &&
		return $DONE || return $RUN
}

function task() {
	sudo echo "$CONFIG" >/etc/X11/xorg.conf.d/30-touchpad.conf &&
		return $OK
}
