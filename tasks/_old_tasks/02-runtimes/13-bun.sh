#!/usr/bin/env bash

function should_run() {
	has_packages bun && return "$DONE" || return "$RUN"
}

function task() {
	makepkg_task bun && return "$OK"
}
