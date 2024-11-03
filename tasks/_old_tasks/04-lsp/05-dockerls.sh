#!/usr/bin/env bash

function should_run() {
	which docker-langserver && return "$DONE" || return "$RUN"
}

function task() {
	npm i -g dockerfile-language-server-nodejs && return "$OK"
}
