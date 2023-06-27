#!/usr/bin/env bash

function should_run() {
	which ruby && return $DONE || return $RUN
}

function task() {
	asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
	asdf install ruby latest &&
		asdf global ruby latest &&
		return $OK
}
