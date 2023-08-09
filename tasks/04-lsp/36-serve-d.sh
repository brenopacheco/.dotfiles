#!/usr/bin/env bash

function should_run() {
	has_packages serve-d && return "$DONE" || return "$RUN"
}

function task() {
	makepkg_task serve-d && return "$OK"
}
