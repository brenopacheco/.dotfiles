#!/usr/bin/env bash

function should_run() {
	which solargraph && return $DONE || return $RUN
}

function task() {
	gem install solargraph && return $OK
}
