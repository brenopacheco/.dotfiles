#!/usr/bin/env bash

function should_run() {
	which yapf && return $DONE || return $RUN
}

function task() {
	pip3 install yapf && return $OK
}
