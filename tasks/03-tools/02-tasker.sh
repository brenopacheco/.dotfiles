#!/usr/bin/env bash

function should_run() {
	has_packages tasker-go && return "$DONE"
	gpg --list-secret-keys brenoleonhardt@gmail.com || return "$SKIP"
	gpg -d "$HOME/.netrc.gpg" | grep "brenoleonhardt@gmail.com" || return "$SKIP"
	return "$RUN"
}

function task() {
	makepkg_task tasker-go && return "$OK"
}
