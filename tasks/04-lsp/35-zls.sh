#!/usr/bin/env bash

function should_run() {
	return "$SKIP"
	has_packages zls-git && return "$DONE" || return "$RUN"
}

function task() {
	makepkg_task zls-git && return "$OK"
}
