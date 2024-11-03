#!/usr/bin/env bash

function should_run() {
	has_packages netcoredbg && return "$DONE" || return "$RUN"
}

function task() {
	makepkg_task netcoredbg && return "$OK"
}
