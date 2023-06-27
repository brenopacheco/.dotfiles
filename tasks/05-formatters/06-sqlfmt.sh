#!/usr/bin/env bash

function should_run() {
	which sqlfmt && return $DONE || return $RUN
}

function task() {
	pip3 install sqlfmt && return $OK
}
