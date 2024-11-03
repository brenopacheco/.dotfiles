#!/usr/bin/env bash

function should_run() {
	has_packages spotdl && return "$DONE" || return "$RUN"
}

function task() {
	makepkg_task spotdl && return "$OK"
}
