#!/usr/bin/env bash

function should_run() {
	has_packages rustup && return $DONE || return $RUN
}

function task() {
	sudo pacman -S --noconfirm rustup &&
		rustup default nightly &&
		return $OK
}
