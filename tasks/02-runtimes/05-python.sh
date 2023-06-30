#!/usr/bin/env bash

function should_run() {
	which python && which pipx && return $DONE || return $RUN
}

function task() {
	sudo pacman -S --noconfirm python python-pipx && return $OK
}
