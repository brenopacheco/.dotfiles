#!/usr/bin/env bash

function should_run() {
	has_packages sxhkd && return "$DONE" || return "$RUN"
}

function task() {
	makepkg_task sxhkd && return "$OK"
}
