#!/usr/bin/env bash

function should_run() {
	which efm-langserver && return $DONE || return $RUN
}

function task() {
	go install github.com/mattn/efm-langserver@latest &&
		return $OK
}
