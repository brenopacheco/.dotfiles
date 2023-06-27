#!/usr/bin/env bash

function should_run() {
	has_packages rust && return $DONE || return $RUN
}

function task() {
	sudo pacman -S --noconfirm rust && return $OK
}
