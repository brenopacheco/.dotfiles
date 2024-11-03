#!/usr/bin/env bash

packages=(
	"lua-language-server"
	"lls-addons"
)

function should_run() {
	has_packages "${packages[@]}" && return "$DONE" || return "$RUN"
}

function task() {
	sudo pacman -S --noconfirm lua-language-server && 
		makepkg_task lls-addons && return "$OK"
}
