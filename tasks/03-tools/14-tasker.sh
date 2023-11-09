#!/usr/bin/env bash

function should_run() {
	gpg --list-secret-keys brenoleonhardt@gmail.com || return "$SKIP"
	gpg -d "$HOME/.netrc.gpg" | grep "brenoleonhardt@gmail.com" || return "$SKIP"
	has_packages tasker-go && return "$DONE" || return "$RUN"
}

function task() {
	makepkg_task tasker-go && return "$OK"
}
