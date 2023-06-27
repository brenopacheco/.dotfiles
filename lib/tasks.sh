#!/usr/bin/env bash

# Task return types
export RUN=100
export SKIP=101
export DONE=103
export OK=104

# Engine return types
export SKIPPED=200
export SUCCEEDED=201
export FAILED=202
export ERRORED=203
export UNCHANGED=204

## Describes weather a task should be run or not
# Returns
# - RUN(100): should run task
# - SKIP(101): should skip task
# - otherwise stops with error
function should_run() {
	:
}

## Describes the task to be run
# Returns
# - OK(102): task ran with success
# - otherwise the task failed
function task() {
	:
}
