#!/usr/bin/env bash

function should_run() {
	cd files || return
	test -n "$(stow --no -v 2 -t ~/ home 2>&1 | grep LINK)" &&
		return "$RUN" || return "$DONE"
}

function task() {
	cd files || return
	stow -t ~/ home && return "$OK"
}
