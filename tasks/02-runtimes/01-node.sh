#!/usr/bin/env bash

function should_run() {
	which node && which npm && which yarn && return $DONE || return $RUN
}

function task() {
	asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
	asdf install nodejs latest:14 &&
		asdf install nodejs latest:16 &&
		asdf install nodejs latest:18 &&
		asdf install nodejs latest:19 &&
		asdf global nodejs latest &&
		npm i -g yarn &&
		return $OK
}
