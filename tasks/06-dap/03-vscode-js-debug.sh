#!/usr/bin/env bash

function should_run() {
	has_packages vscode-js-debug && return "$DONE" || return "$RUN"
}

function task() {
	makepkg_task vscode-js-debug && return "$OK"
}
