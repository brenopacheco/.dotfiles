#!/usr/bin/env bash

function should_run() {
	has_packages slack-desktop && return "$DONE" || return "$RUN"
}

function task() {
	makepkg_task slack-desktop && return "$OK"
}
