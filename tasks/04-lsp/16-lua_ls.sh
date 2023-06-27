#!/usr/bin/env bash

function should_run() {
	has_packages lua-language-server && return $DONE || return $RUN
}

function task() {
	sudo pacman -S --noconfirm lua-language-server && return $OK
}
