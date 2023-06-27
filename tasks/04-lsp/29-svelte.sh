#!/usr/bin/env bash

function should_run() {
	which svelteserver && return $DONE || return $RUN
}

function task() {
	npm i -g svelte-language-server && return $OK
}
