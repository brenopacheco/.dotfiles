#!/usr/bin/env bash

function should_run() {
	has_packages staticcheck && return $DONE || return $RUN
}

function task() {
	sudo pacman -S --noconfirm staticcheck && return $OK
}
