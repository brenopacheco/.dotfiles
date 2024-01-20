#!/usr/bin/env bash

conf="/etc/systemd/logind.conf"

function should_run() {
	grep "#IdleAction" "$conf" && return "$RUN" || return "$DONE"
}

function task() {
	sudo sed -i 's/#\?IdleAction=.*/IdleAction=suspend/' "$conf" &&
		sudo sed -i 's/#\?IdleActionSec=.*/IdleActionSec=15min/' "$conf" &&
		return "$OK"
}
