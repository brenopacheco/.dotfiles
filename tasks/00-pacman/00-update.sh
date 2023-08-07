#!/usr/bin/env bash

function should_run() {
	are_packages_synced && return "$DONE" || return "$RUN"
}

function task() {
	sudo pacman -Syu --noconfirm && return "$OK"
}
