#!/usr/bin/env bash
#
# To enable virtual cam:
# 1. make sue v4l2loopback-dkms is installed with the correct kernel headers
# 2. sudo modprobe v4l2loopback exclusive_caps=1 card_label='OBS Virtual Camera'

function should_run() {
	has_packages obs-studio && has_packages obs-backgroundremoval && return "$DONE" || return "$RUN"
}

function task() {
	sudo pacman -S --noconfirm obs-studio &&
		makepkg_task obs-backgroundremoval && return "$OK"
}
