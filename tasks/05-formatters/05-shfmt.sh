#!/usr/bin/env bash

function should_run() {
	which shfmt && return $DONE || return $RUN
}

function task() {
	go install mvdan.cc/sh/v3/cmd/shfmt@latest &&
		which shfmt &&
		return $OK
		# asdf reshim golang &&
}
