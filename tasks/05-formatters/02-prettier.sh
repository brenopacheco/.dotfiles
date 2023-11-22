#!/usr/bin/env bash

function should_run() {
	which prettier &&
		which prettierd &&
		return "$DONE" || return "$RUN"
}

function task() {
	npm i -g prettier @fsouza/prettierd && return "$OK"
}
