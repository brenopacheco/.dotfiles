#!/usr/bin/env bash

packages=(
	"lightdm"
	"lightdm-gtk-greeter"
)

function should_run() {
	has_packages "${packages[@]}" || return "$RUN"
	systemctl is-enabled lightdm || return "$RUN"
	return "$DONE"
}

function task() {
	sudo pacman -S --noconfirm "${packages[@]}" &&
		sudo systemctl enable lightdm && return "$OK"
}
