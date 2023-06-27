#!/usr/bin/env bash

function should_run() {
	which pylyzer && return $DONE || return $RUN
}

function task() {
	cargo install pylyzer && return $OK
}
