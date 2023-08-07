#!/usr/bin/env bash

function should_run() {
	which cmake-language-server && return "$DONE" || return "$RUN"
}

function task() {
	pipx install cmake-language-server && return "$OK"
}
