#!/usr/bin/env bash

function should_run() {
	has_packages delve && return "$DONE" || return "$RUN"
}

function task() {
	sudo pacman -S --noconfirm delve && return "$OK"
}
