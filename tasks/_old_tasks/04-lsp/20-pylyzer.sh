#!/usr/bin/env bash

function should_run() {
	return "$SKIP"
	which pylyzer && return "$DONE" || return "$RUN"
}

function task() {
	cargo install pylyzer && return "$OK"
}
