#!/usr/bin/env bash

function should_run() {
	which python && return $DONE || return $RUN
}

function task() {
	sudo pacman -S --noconfirm python && return $OK
}
