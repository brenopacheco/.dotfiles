#!/usr/bin/env bash

function should_run() {
	which java && which mvn && return "$DONE" || return "$RUN"
}

function task() {
	asdf plugin-add java https://github.com/halcyon/asdf-java.git
	asdf install java openjdk-9:latest &&
		asdf install java openjdk-11:latest &&
		asdf install java openjdk-13:latest &&
		asdf install java openjdk-17:latest &&
		asdf global java openjdk-17 &&
		asdf reshim &&
		sudo pacman -S --noconfirm maven &&
		return "$OK"
}
