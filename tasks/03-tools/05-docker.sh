#!/usr/bin/env bash

packages=(
	"docker"
	"docker-compose"
)

function should_run() {
	has_packages "${packages[@]}" && return "$DONE" || return "$RUN"
}

function task() {
	sudo pacman -S --noconfirm "${packages[@]}" &&
		sudo systemctl enable docker.service &&
		sudo systemctl start docker.service &&
		sudo usermod -aG docker "$USER" &&
		return "$OK"
}
