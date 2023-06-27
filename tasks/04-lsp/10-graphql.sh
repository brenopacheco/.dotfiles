#!/usr/bin/env bash

function should_run() {
	which graphql-lsp && return $DONE || return $RUN
}

function task() {
	npm i -g graphql-language-service-cli && return $OK
}
