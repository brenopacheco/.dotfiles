#!/usr/bin/env bash

function should_run() {
	cd files || return
	test -n "$(stow --no -v 2 -t ~/ home 2>&1 | grep LINK)" &&
		return "$RUN" || return "$DONE"
}

function task() {
	test -f ~/.bashrc && rm ~/.bashrc
	test -f ~/.config/mimeapps.list && rm ~/.config/mimeapps.list
	cd files && stow -t ~/ home && return "$OK"
}
