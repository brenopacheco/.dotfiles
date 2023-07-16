#!/usr/bin/env bash

function should_run() {
	npm list -g @styled/typescript-styled-plugin --depth=0 && return $SKIP || return $RUN
}

function task() {
	npm install -g @styled/typescript-styled-plugin && return $OK
}
