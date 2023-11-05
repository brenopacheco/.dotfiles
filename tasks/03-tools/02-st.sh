#!/usr/bin/env bash

function should_run() {
	return "$SKIP"
	has_packages st-fork && return "$DONE" || return "$RUN"
}

function task() {
	makepkg_task st-fork && return "$OK"
}
