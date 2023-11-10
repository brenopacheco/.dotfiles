#!/usr/bin/env bash

function should_run() {
	has_packages cmus && return "$DONE" || return "$RUN"
}

function task() {
	sudo pacman -S --noconfirm cmus && return "$OK"
	# TODO: add configurations
}
