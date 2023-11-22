#!/usr/bin/env bash

function should_run() {
	which sqlformat && return "$DONE" || return "$RUN"
}

function task() {
	pipx install sqlparse && return "$OK"
}
