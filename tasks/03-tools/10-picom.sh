#!/usr/bin/env bash

function should_run() {
	has_packages picom-pijulius-git && return $DONE || return $RUN
}

function task() {
	makepkg_task picom-pijulius-git && return $OK
}
