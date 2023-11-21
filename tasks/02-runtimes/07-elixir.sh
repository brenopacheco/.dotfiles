#!/usr/bin/env bash

function should_run() {
	which iex && return "$DONE" || return "$RUN"
}

function task() {
	asdf plugin add elixir https://github.com/asdf-vm/asdf-elixir.git
	KERL_BUILD_DOCS="yes" asdf install elixir latest &&
		asdf global elixir latest &&
		asdf reshim &&
		return "$OK"
}
