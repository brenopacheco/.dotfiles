#!/usr/bin/env bash

# https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=k3s-bin

function should_run() {
	which kind && return "$DONE" || return "$RUN"
}

function task() {
	go install sigs.k8s.io/kind@v0.20.0 && return "$OK"
}
