#!/usr/bin/env bash

function should_run() {
	gpg --list-secret-keys brenoleonhardt@gmail.com && return "$DONE"
	return "$RUN"
}

function task() {
	echo "Please manually import the gnupg keyring (copy files to ~/.gnupg/)"
	exit 1
}
