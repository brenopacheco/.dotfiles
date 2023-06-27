#!/usr/bin/env bash

packages=(
	"docker"
	"docker-compose"
)

function should_run() {
	has_packages $packages && return $DONE || return $RUN
}

function task() {
	sudo pacman -S ${packages[*]} &&
		systemctl enable docker.service &&
		systemctl start docker.service &&
		usermod -aG docker $USER &&
		return $OK
}
