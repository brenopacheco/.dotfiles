#!/usr/bin/env bash

function should_run() {
	has_packages shellcheck && return "$DONE" || return "$RUN"
}

function task() {
	sudo pacman -S --noconfirm shellcheck && return "$OK"
}
