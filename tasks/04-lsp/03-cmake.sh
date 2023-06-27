#!/usr/bin/env bash

function should_run() {
	which cmake-language-server && return $DONE || return $RUN
}

function task() {
	pip3 install cmake-language-server && return $OK
}
