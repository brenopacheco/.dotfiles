#!/usr/bin/env bash

function should_run() {
	which prisma-language-server && return "$DONE" || return "$RUN"
}

function task() {
	npm i -g @prisma/language-server && return "$OK"
}
