#!/usr/bin/env bash

function should_run() {
	file ~/.asdf/asdf.sh && return "$DONE" || return "$RUN"
}

function task() {
	# shellcheck disable=SC1090
	git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.12.0 &&
		source ~/.asdf/asdf.sh &&
		return "$OK"
}
