#!/usr/bin/env bash

RULE=$(
	cat <<'EOF'
ACTION=="add", ATTR{idVendor}=="1d6c", ATTR{idProduct}=="0103", RUN="/bin/sh -c 'echo 0 >/sys/\$devpath/authorized'"
EOF
)

function should_run() {
	test -e /etc/udev/rules.d/90-block-webcam-sound.rules && return "$DONE" || return "$RUN"
}

function task() {
	echo "$RULE" | sudo tee /etc/udev/rules.d/90-block-webcam-sound.rules &&
		return "$OK"
}
