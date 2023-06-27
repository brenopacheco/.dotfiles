#!/usr/bin/env bash

SRC_ROOT="$(dirname "${BASH_SOURCE}")"
source "${SRC_ROOT}/pacman.sh"
source "${SRC_ROOT}/terminal.sh"
source "${SRC_ROOT}/tasks.sh"
width=$(tput cols)

function runner() {
	script=$1
	debug=$2

	tmpfile=$(mktemp)
	prefix=" - TASK: $script"
	message "$prefix" "CHECKING"

	# shellcheck source=./template.sh
	source "$script"
	if [[ $? -ne 0 ]]; then
		message "$prefix" "ERROR(SOURCING TASK)"
		return 1
	fi

	async_run $tmpfile should_run
	exit_status=$?

	clear_previous_line

	case $exit_status in
	$RUN)
		message "$prefix" "RUNNING "
		async_run $tmpfile task
		exit_status=$?
		clear_previous_line
		if [[ $exit_status -eq $OK ]]; then
			message "$prefix" "SUCCESS "
			if [[ $debug == true ]]; then
				cat $tmpfile
			fi
			return $SUCCEEDED
		fi
		message "$prefix" "FAILURE "
		cat $tmpfile >&2
		return $FAILED
		;;
	$SKIP)
		message "$prefix" "SKIPPED "
		if [[ $debug == true ]]; then
			cat $tmpfile
		fi
		return $SKIPPED
		;;
	$DONE)
		message "$prefix" "NOTHING TO DO "
		if [[ $debug == true ]]; then
			cat $tmpfile
		fi
		return $UNCHANGED
		;;
	*)
		message "$prefix" "ERROR(SHOULD RUN FAILED) "
		cat $tmpfile >&2
		return $ERRORED
		;;
	esac
}
