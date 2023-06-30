#!/usr/bin/env bash

# TODO: For some reason, every time alacritty is launched it has SHLVL of 2
#       by default. The same happens to kitty, but not st or xterm

function should_run() {
	has_packages alacritty && return $DONE || return $RUN
}

function task() {
	sudo pacman -S --noconfirm alacritty && return $OK
}
