#!/usr/bin/env bash

function should_run() {
	which goimports && return $DONE || return $RUN
}

function task() {
	go install golang.org/x/tools/cmd/goimports@latest &&
		which goimports &&
		return $OK
}
