#!/usr/bin/env bash

function should_run() {
	which stylua && return "$DONE" || return "$RUN"
}

function task() {
	cargo install stylua && return "$OK"
}
