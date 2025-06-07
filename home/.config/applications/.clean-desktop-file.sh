#!/usr/bin/env bash

FIELDS=(
	"Name"
	"StartupWMClass"
	"Comment"
	"Exec"
	"Terminal"
	"Icon"
	"Type"
	"StartupNotify"
	"Categories"
	"MimeType"
)

mkdir -p parsed

PATTERN=$(echo "${FIELDS[@]}" | sed 's/ /|/g')
PATTERN="^(${PATTERN})="

for i in *.desktop; do
	grep -E "${PATTERN}" "$i" > "./parsed/$i"
done
