#!/usr/bin/env bash

function should_run() {
	test -d "$HOME/notes" && return "$DONE" || return "$RUN"
	gpg --list-secret-keys brenoleonhardt@gmail.com || return "$SKIP"
	gpg -d "$HOME/.netrc.gpg" | grep "brenoleonhardt@gmail.com" || return "$SKIP"
}

function task() {
	cd "$HOME" || return
	git clone https://github.com/brenopacheco/notes.git "$HOME/notes" &&
		return "$OK"
}
