#!/usr/bin/env bash
# Make sure gpg-agent service is running on login, so that it can be used as
# an ssh-agent automatically.

function should_run() {
	systemctl is-enabled --user gpg-agent.target || return "$RUN"
	return "$DONE"
}

function task() {
	systemctl enable --user gpg-agent.service && return "$OK"
}
