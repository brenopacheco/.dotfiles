#!/usr/bin/env bash

function should_run() {
	test -d "$HOME/.notes" && return "$DONE" || return "$RUN"
}

function task() {
	cd "$HOME" || return
	git clone https://github.com/brenopacheco/notes.git "$HOME/.notes"
}
