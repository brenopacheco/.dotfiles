#!/usr/bin/env bash

function should_run() {
	has_packages firefox && return "$DONE" || return "$RUN"
}

function task() {
	sudo pacman -S --noconfirm firefox && return "$OK"
}
