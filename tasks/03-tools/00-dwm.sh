#!/usr/bin/env bash

function should_run() {
	has_packages dwm-fork && return $DONE || return $RUN
}

function task() {
	makepkg_task dwm && return $OK
}
