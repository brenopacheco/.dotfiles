#!/usr/bin/env bash

function should_run() {
	gpg --list-secret-keys brenoleonhardt@gmail.com || return $SKIP
	gpg -d $HOME/.netrc.gpg | grep "brenoleonhardt@gmail.com" || return $SKIP
	test -d $HOME/.password-store && return $DONE || return $RUN
}

function task() {
	cd $HOME
	git clone https://github.com/brenopacheco/.password-store.git
}
