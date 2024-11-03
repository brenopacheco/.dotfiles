#!/usr/bin/env bash

function should_run() {
	which sql-language-server && return "$DONE" || return "$RUN"
}

function task() {
	npm i -g sql-language-server && return "$OK"
}
