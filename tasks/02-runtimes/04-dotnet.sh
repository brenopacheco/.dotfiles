#!/usr/bin/env bash

function should_run() {
	which dotnet && return "$DONE" || return "$RUN"
}

function task() {
	asdf plugin-add dotnet-core https://github.com/emersonsoares/asdf-dotnet-core.git
	asdf install dotnet-core 5 &&
		asdf install dotnet-core 6 &&
		asdf install dotnet-core 7 &&
		return "$OK"
}
