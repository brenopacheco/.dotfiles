#!/usr/bin/env bash

function should_run() {
	test -d "$HOME/.password-store" && return "$DONE"
	gpg --list-secret-keys brenoleonhardt@gmail.com || return "$SKIP"
	gpg -d "$HOME/.netrc.gpg" | grep "brenoleonhardt@gmail.com" || return "$SKIP"
	return "$RUN"
}

function task() {
	cd "$HOME" || return
	git clone https://github.com/brenopacheco/.password-store.git "$HOME/.password-store" &&
		return "$OK"
}
