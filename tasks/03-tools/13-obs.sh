#!/usr/bin/env bash

function should_run() {
	has_packages obs-studio obs-backgroundremoval && return "$DONE" || return "$RUN"
}

function task() {
	sudo pacman -S --noconfirm obs-studio &&
		makepkg_task obs-backgroundremoval && return "$OK"
}
