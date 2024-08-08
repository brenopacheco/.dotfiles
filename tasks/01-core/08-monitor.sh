#!/usr/bin/env bash

CONFIG=$(
	cat <<'EOF'
Section "Monitor"
    Identifier "HDMI-A-0"
    Option "Primary" "true"
    Option "PreferredMode" "1920x1080"
    Option "Position" "0 0"
    Option "Rotate" "normal"
EndSection

Section "Monitor"
    Identifier "DP-1"
    Option "PreferredMode" "1920x1080"
    Option "Position" "1920 0"
    Option "Rotate" "normal"
EndSection

Section "Screen"
    Identifier "Screen0"
    Monitor "HDMI-A-0"
    Monitor "DP-1"
EndSection

Section "Device"
    Identifier "Device0"
    Driver "amdgpu"
EndSection

Section "ServerLayout"
    Identifier "DualMonitors"
    Screen 0 "Screen0"
EndSection
EOF
)

FILE="/etc/X11/xorg.conf.d/10-monitor.conf"

function should_run() {
	test -e "$FILE" && return "$DONE" || return "$RUN"
}

function task() {
	echo "$CONFIG" | sudo tee "$FILE" && return "$OK"
}
