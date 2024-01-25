#!/usr/bin/env bash

function should_run() {
	has_packages fennel-ls && return "$DONE" || return "$RUN"
}

function task() {
	makepkg_task fennel-ls && return "$OK"
}
