#!/usr/bin/env bash

packages=(
	"dotnet-sdk"
	"dotnet-sdk-6.0"
	"dotnet-sdk-7.0"
	"dotnet-runtime"
	"dotnet-runtime-6.0"
	"dotnet-runtime-7.0"
	"aspnet-runtime"
	"aspnet-runtime-6.0"
	"aspnet-runtime-7.0"
)

function should_run() {
	has_packages "${packages[@]}" && return "$DONE" || return "$RUN"
}

function task() {
	sudo pacman -S --noconfirm "${packages[@]}" && return "$OK"
}
