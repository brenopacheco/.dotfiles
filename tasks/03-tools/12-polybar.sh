#!/usr/bin/env bash

function should_run() {
	return "$SKIP" 
	has_packages polybar && return "$DONE" || return "$RUN"
}

function task() {
	makepkg_task polybar && return "$OK"
}
