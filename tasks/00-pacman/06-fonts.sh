#!/usr/bin/env bash
# ttf-firacode-nerd > 3.* will have missing icons for some apps

function should_run() {
	has_packages ttf-firacode-nerd && return "$DONE" || return "$RUN"
}

function task() {
	makepkg_task ttf-firacode-nerd && fc-cache -f -v && return "$OK"
}
