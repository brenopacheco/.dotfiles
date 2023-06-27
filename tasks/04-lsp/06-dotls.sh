#!/usr/bin/env bash

function should_run() {
	which dot-language-server && return $DONE || return $RUN
}

function task() {
	npm i -g dot-language-server && return $OK
}
