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

FILE="/etc/X11/xorg.conf.d/30-touchpad.conf"

function should_run() {
	test -e "$FILE" && return "$DONE" || return "$RUN"
}

function task() {
	echo "$CONFIG" | sudo tee "$FILE" && return "$OK"
}
