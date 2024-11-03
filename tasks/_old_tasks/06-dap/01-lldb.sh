#!/usr/bin/env bash

function should_run() {
	has_packages lldb && return "$DONE" || return "$RUN"
}

function task() {
	sudo pacman -S --noconfirm lldb && return "$OK"
}
