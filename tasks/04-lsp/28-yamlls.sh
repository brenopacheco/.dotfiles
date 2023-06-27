#!/usr/bin/env bash

function should_run() {
	which yaml-language-server && return $DONE || return $RUN
}

function task() {
	npm i -g yaml-language-server && return $OK
}
