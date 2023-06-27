#!/usr/bin/env bash
# gem install solargraph

function should_run() {
	which solargraph && return $DONE || return $RUN
}

function task() {
	gem install solargraph && return $OK
}
