#!/usr/bin/env bash

function should_run() {
	has_packages twitch-notify && return "$DONE"
	gpg --list-secret-keys brenoleonhardt@gmail.com || return "$SKIP"
	gpg -d "$HOME/.netrc.gpg" | grep "brenoleonhardt@gmail.com" || return "$SKIP"
	return "$RUN"
}

function task() {
	makepkg_task twitch-notify && return "$OK"
}
