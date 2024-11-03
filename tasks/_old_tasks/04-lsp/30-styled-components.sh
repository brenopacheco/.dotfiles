#!/usr/bin/env bash

function should_run() {
	npm list -g @styled/typescript-styled-plugin --depth=0 && return "$DONE" || return "$RUN"
}

function task() {
	npm install -g @styled/typescript-styled-plugin && return "$OK"
}
