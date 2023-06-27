#!/usr/bin/env bash

function should_run() {
	which erl && return $DONE || return $RUN
}

function task() {
	asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git
	KERL_BUILD_DOCS="yes" asdf install erlang latest &&
		asdf global erlang latest &&
		return $OK
}
