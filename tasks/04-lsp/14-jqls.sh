#!/usr/bin/env bash

function should_run() {
	which jq-lsp && return "$DONE" || return "$RUN"
}

function task() {
	go install github.com/wader/jq-lsp@latest &&
		return "$OK"
		# asdf reshim golang &&
}
