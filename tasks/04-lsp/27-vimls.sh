#!/usr/bin/env bash

function should_run() {
	which vim-language-server && return $DONE || return $RUN
}

function task() {
	npm i -g vim-language-server && return $OK
}
