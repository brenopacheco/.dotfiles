#!/usr/bin/env bash

function should_run() {
	which golines && return "$DONE" || return "$RUN"
}

function task() {
	go install github.com/segmentio/golines@latest &&
		which golines &&
		return "$OK"
}
