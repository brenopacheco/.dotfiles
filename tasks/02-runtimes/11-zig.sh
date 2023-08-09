#!/usr/bin/env bash

function should_run() {
	which zig && return "$DONE" || return "$RUN"
}

function task() {
	asdf plugin add elixir https://github.com/asdf-community/asdf-zig.git
	asdf install zig latest &&
		asdf global zig latest &&
		return "$OK"
}
