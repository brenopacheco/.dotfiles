#!/usr/bin/env bash

function should_run() {
	has_packages shfmt && return $DONE || return $RUN
}

function task() {
	sudo pacman -S --noconfirm shfmt && return $OK
}
