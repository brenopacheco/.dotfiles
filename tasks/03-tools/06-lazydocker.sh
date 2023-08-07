#!/usr/bin/env bash

function should_run() {
	which lazydocker && return "$DONE" || return "$RUN"
}

function task() {
	go install github.com/jesseduffield/lazydocker@latest &&
		which lazydocker &&
		return "$OK"
		# asdf reshim golang &&
}
