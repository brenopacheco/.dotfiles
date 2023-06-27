#!/usr/bin/env bash

function should_run() {
	has_packages clang && return $DONE || return $RUN
}

function task() {
	sudo pacman -S --noconfirm clang && return $OK
}
