#!/usr/bin/env bash

function should_run() {
	which vscode-eslint-language-server && return "$DONE" || return "$RUN"
}

function task() {
	npm i -g vscode-langservers-extracted && return "$OK"
}
