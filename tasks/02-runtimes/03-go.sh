#!/usr/bin/env bash

function should_run() {
	which go && return "$DONE" || return "$RUN"
}

function task() {
	sudo pacman -S --noconfirm go && 
		go install golang.org/x/tools/cmd/godoc@latest &&
		return "$OK"
}
