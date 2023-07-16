#!/usr/bin/env bash

function should_run() {
	which lf && return $DONE || return $RUN
}

function task() {
	env CGO_ENABLED=0 go install -ldflags="-s -w" github.com/gokcehan/lf@latest &&
		which lf &&
		return $OK
		# asdf reshim golang &&
}
