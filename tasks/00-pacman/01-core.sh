#!/usr/bin/env bash

packages=(
	"base"
	"base-devel"
	"git"
	"cmake"
	"ninja"
	"stow"
	"vim"
)

function should_run() {
	has_packages "${packages[@]}" && return "$DONE" || return "$RUN"
}

function task() {
	sudo pacman -S --noconfirm "${packages[*]}" && return "$OK"
}
