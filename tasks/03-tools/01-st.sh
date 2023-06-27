#!/usr/bin/env bash

function should_run() {
	has_packages st-fork && return $DONE || return $RUN
}

function task() {
	makepkg_task st && return $OK
}
