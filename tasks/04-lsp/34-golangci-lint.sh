#!/usr/bin/env bash

function should_run() {
	has_packages golangci-lint && return "$DONE" || return "$RUN"
}

function task() {
	makepkg_task golangci-lint && return "$OK"
}
