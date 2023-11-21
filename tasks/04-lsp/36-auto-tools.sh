#!/usr/bin/env bash

function should_run() {
	which autotools-language-server && return "$DONE" || return "$RUN"
}

function task() {
	pipx install autotools-language-server && return "$OK"
}
