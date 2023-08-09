#!/usr/bin/env bash

packages=(
	'dfmt'
	'dmd'
	'dmd-docs'
	'dscanner'
	'dtools'
	'dub'
	'ldc'
	'libphobos'
	'lld'
)

function should_run() {
	has_packages "${packages[@]}" && return "$DONE" || return "$RUN"
}

function task() {
	sudo pacman -S --noconfirm "${packages[*]}" && return "$OK"
}
