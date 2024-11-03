#!/usr/bin/env bash

packages=(
	"bluez-utils"
)

function should_run() {
	has_packages "${packages[@]}" || return "$RUN"
	systemctl is-enabled bluetooth || return "$RUN"
	return "$DONE"
}

function task() {
	sudo pacman -S --noconfirm "${packages[@]}" &&
		sudo systemctl enable bluetooth && return "$OK"
}
