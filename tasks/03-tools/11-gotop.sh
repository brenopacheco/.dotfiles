#!/usr/bin/env bash

function should_run() {
	has_packages gotop && return "$DONE" || return "$RUN"
}

function task() {
	makepkg_task gotop && return "$OK"
}
