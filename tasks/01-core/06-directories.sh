#!/usr/bin/env bash

dirs=(
	"git"
	"sketch"
	"tmp"
)

function should_run() {
	for dir in "${dirs[@]}"; do
		test -d "$HOME/$dir" || return "$RUN"
	done
	return "$DONE"
}

function task() {
	cd "$HOME" && mkdir -p "${dirs[@]}" && return "$OK"
}
