#!/usr/bin/env bash

function should_run() {
	which go && return $DONE || return $RUN
}

function task() {
	asdf plugin-add golang https://github.com/kennyp/asdf-golang.git &&
		asdf install golang latest &&
		asdf global golang latest &&
		return $OK
}
