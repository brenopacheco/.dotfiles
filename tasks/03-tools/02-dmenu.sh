#!/usr/bin/env bash

function should_run() {
	has_packages "dmenu-fork" && return "$DONE" || return "$RUN"
}

function task() {
	makepkg_task dmenu-fork && return "$OK"
}
