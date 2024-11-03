#!/usr/bin/env bash

function should_run() {
	which yaml-language-server && return "$DONE" || return "$RUN"
}

function task() {
	yarn global add yaml-language-server && return "$OK"
}
