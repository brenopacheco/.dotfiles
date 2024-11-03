#!/usr/bin/env bash

function should_run() {
	which yq && return "$DONE" || return "$RUN"
}

function task() {
	go install github.com/mikefarah/yq/v4@latest \
		which yq &&
		return "$OK"
}
