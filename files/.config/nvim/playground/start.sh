#!/usr/bin/env bash

usage() {
    echo 'Usage: play <file>'
    echo 'Play vim in a sandbox.'
}

if [[ $# -eq 0 ]]; then
    usage
    printf "\n...No filename supplied\n" >&2
    exit 1
fi

if [[ ! -e "$1" ]]; then
    usage
    printf "\n...File not found\n" >&2
    exit 1
fi

printf 'Starting sandboxed vim with file %s\n' "$1"

nvim -u "$1"
