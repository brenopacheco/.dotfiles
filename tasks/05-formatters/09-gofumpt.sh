#!/usr/bin/env bash

function should_run() {
	which gofumpt && return "$DONE" || return "$RUN"
}

function task() {
	go install mvdan.cc/gofumpt@latest &&
		which gofumpt &&
		return "$OK"
}
