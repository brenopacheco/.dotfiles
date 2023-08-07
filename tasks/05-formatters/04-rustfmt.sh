#!/usr/bin/env bash

function should_run() {
	which rustfmt && return "$DONE" || return "$RUN"
}

function task() {
	cargo install rustfmt && return "$OK"
}
