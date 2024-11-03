#!/usr/bin/env bash

function should_run() {
	has_packages rust-analyzer && return "$DONE" || return "$RUN"
}

function task() {
	sudo pacman -S --noconfirm rust-analyzer && return "$OK"
}
