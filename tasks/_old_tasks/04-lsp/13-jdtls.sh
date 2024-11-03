#!/usr/bin/env bash

function should_run() {
	which jdtls && return "$DONE" || return "$RUN"

}

function task() {
	makepkg_task jdtls && return "$OK"
}
