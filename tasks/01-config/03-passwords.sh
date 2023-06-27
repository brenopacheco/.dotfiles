#!/usr/bin/env bash

function should_run() {
	gpg --list-secret-keys brenoleonhardt@gmail.com || return $SKIP
	gpg -d ~/.netrc.gpg | grep "brenoleonhardt@gmail.com" || return $SKIP
	test -d ~/.passwords && return $DONE || return $RUN
}

function task() {
	cd $HOME
	git clone https://github.com/brenopacheco/.passwords
	gpg -d .passwords/pass.tar.gz.asc | tar -C / -xz
}
