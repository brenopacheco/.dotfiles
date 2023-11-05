#!/usr/bin/env bash

function should_run() {
	has_packages "slstatus-fork" && return "$DONE" || return "$RUN"
}

function task() {
	makepkg_task slstatus-fork && return "$OK"
}
