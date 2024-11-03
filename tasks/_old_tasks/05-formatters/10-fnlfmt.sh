#!/usr/bin/env bash

function should_run() {
	has_packages fnlfmt && return "$DONE" || return "$RUN"
}

function task() {
	sudo pacman -S --noconfirm fnlfmt && return "$OK"
}
