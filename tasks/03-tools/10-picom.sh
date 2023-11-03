#!/usr/bin/env bash

function should_run() {
	return "$SKIP"
	has_packages picom-git && return "$DONE" || return "$RUN"
}

function task() {
	makepkg_task picom-git && return "$OK"
}
