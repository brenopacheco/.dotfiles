#!/usr/bin/env bash

function should_run() {
	which gopls && return $DONE || return $RUN
}

function task() {
	go install golang.org/x/tools/gopls@latest &&
		asdf reshim golang &&
		return $OK
}
