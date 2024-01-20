#!/usr/bin/env bash

# NOTE: TROUBLESHOOTING CAMERA
# Sometimes the camera is detected by `lsusb` but not by `v4l2-ctl --list-devices`.
# This may be caused by the uvcvideo module not being loaded - run `modprobe -a uvcvideo`
# Also check that `v4l2loopback-dkms` is installed using the correct kernel
# headers - `linux-zen-headers` or `linux-headers` depending on the kernel.

RULE=$(
	cat <<'EOF'
ACTION=="add", ATTR{idVendor}=="1d6c", ATTR{idProduct}=="0103", RUN="/bin/sh -c 'echo 0 >/sys/\$devpath/authorized'"
EOF
)

function should_run() {
	return "$SKIP" # this makes the cam not be recognized
	test -e /etc/udev/rules.d/90-block-webcam-sound.rules && return "$DONE" || return "$RUN"
}

function task() {
	echo "$RULE" | sudo tee /etc/udev/rules.d/90-block-webcam-sound.rules &&
		return "$OK"
}
