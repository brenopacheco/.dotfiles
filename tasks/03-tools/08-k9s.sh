#!/usr/bin/env bash

function should_run() {
	has_packages k9s && return "$DONE" || return "$RUN"
}

function task() {
	sudo pacman -S --noconfirm k9s && return "$OK"
}
