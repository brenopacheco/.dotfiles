#!/usr/bin/env bash

function should_run() {
	which go && return "$DONE" || return "$RUN"
}

function task() {
	sudo pacman -S --noconfirm go && 
		go install go install golang.org/x/tools/cmd/godoc@latest &&
		return "$OK"

	# asdf plugin-add golang https://github.com/kennyp/asdf-golang.git &&
	# 	asdf install golang latest &&
	# 	asdf global golang latest &&
	# 	return "$OK"
}
