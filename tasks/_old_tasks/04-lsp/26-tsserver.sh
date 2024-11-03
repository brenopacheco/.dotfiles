#!/usr/bin/env bash

function should_run() {
	which typescript-language-server && return "$DONE" || return "$RUN"
}

function task() {
	npm i -g typescript typescript-language-server && return "$OK"
}
