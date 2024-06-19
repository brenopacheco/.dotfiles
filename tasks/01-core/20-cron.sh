#!/usr/bin/env bash

packages=(
	"cronie"
)

function should_run() {
	has_packages "${packages[@]}" || return "$RUN"
	systemctl is-enabled cronie || return "$RUN"
	return "$DONE"
}

function task() {
	sudo pacman -S --noconfirm "${packages[@]}" &&
		sudo systemctl enable cronie.service && return "$OK"
}
