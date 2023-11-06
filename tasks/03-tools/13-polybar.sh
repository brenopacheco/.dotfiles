#!/usr/bin/env bash

function should_run() {
	has_packages polybar && return "$DONE" || return "$RUN"
}

function task() {
	sudo pacman -S --noconfirm polybar && return "$OK"
}
