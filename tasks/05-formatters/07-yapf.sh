#!/usr/bin/env bash

function should_run() {
	which yapf && return $DONE || return $RUN
}

function task() {
	pipx install yapf && return $OK
}
