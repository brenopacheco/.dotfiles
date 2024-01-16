#!/usr/bin/env bash
#
# To enable virtual cam:
# 1. make sue v4l2loopback-dkms is installed with the correct kernel headers
# 2. sudo modprobe v4l2loopback exclusive_caps=1 card_label='OBS Virtual Camera'

packages=(
	obs-studio
	obs-backgroundremoval
	v4l2loopback-dkms
)

module="v4l2loopback"
options="exclusive_caps=1 card_label='OBS Virtual Camera'"

function should_run() {
	has_packages "${packages[@]}" || return "$RUN"
	test -f /etc/modules-load.d/v4l2loopback.conf || return "$RUN"
	test -f /etc/modprobe.d/v4l2loopback.conf || return "$RUN"
	return "$DONE"
}

function task() {
	sudo pacman -S --noconfirm obs-studio &&
		makepkg_task obs-backgroundremoval &&
		echo "$module" | sudo tee "/etc/modules-load.d/$module.conf" &&
		echo "$options" | sudo tee "/etc/modprobe.d/$module.conf" &&
		return "$OK"
}
