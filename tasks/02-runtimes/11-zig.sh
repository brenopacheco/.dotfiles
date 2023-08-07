#!/usr/bin/env bash

function should_run() {
	has_packages zig && return "$DONE" || return "$RUN"
}

function task() {
	makepkg_task zig && return "$OK"
}
