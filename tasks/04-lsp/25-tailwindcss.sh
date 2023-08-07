#!/usr/bin/env bash

function should_run() {
	which tailwindcss-language-server && return "$DONE" || return "$RUN"
}

function task() {
	npm i -g @tailwindcss/language-server && return "$OK"
}
