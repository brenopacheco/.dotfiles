#!/usr/bin/env bash

# TODO: create PKGBUILD

function should_run() {
	return $SKIP
	which dotnet && return "$DONE" || return "$RUN"
}

function task() {
	sudo pacman -S --noconfirm dotnet-runtime &&
		curl -sSL https://dot.net/v1/dotnet-install.sh -o /tmp/dotnet-install.sh &&
		chmod +x /tmp/dotnet-install.sh &&
		sudo /tmp/dotnet-install.sh --install-dir /usr/share/dotnet -channel STS -version latest &&
		return "$OK"
}
