#!/usr/bin/env bash

function should_run() {
	has_packages azuredatastudio && return "$DONE" || return "$RUN"
}

function task() {
	makepkg_task azuredatastudio && return "$OK"
}
