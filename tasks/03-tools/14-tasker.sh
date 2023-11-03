#!/usr/bin/env bash

function should_run() {
	has_packages tasker-go && return "$DONE" || return "$RUN"
}

function task() {
	makepkg_task tasker-go && return "$OK"
}
