#!/usr/bin/env bash

function should_run() {
	which bash-language-server && return "$DONE" || return "$RUN"
}

function task() {
	npm i -g bash-language-server && return "$OK"
}
