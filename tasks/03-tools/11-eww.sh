#!/usr/bin/env bash

function should_run() {
	return "$SKIP"
	has_packages eww-x11 && return "$DONE" || return "$RUN"
}

function task() {
	makepkg_task eww-x11 && return "$OK"
}
