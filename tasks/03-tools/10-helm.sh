#!/usr/bin/env bash

function should_run() {
	has_packages helm && return "$DONE" || return "$RUN"
}

function task() {
	sudo pacman -S --noconfirm helm && return "$OK"
}
