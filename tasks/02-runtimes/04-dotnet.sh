#!/usr/bin/env bash

# TODO: fix this. something is not right, where does /bin/dotnet come from?
function should_run() {
	return "$SKIP"
	which dotnet && return "$DONE" || return "$RUN"
}

function task() {
	asdf plugin-add dotnet-core https://github.com/emersonsoares/asdf-dotnet-core.git
	asdf install dotnet-core 5 &&
		asdf install dotnet-core 6 &&
		asdf install dotnet-core 7 &&
		asdf global dotnet-core 7 &&
		asdf reshim &&
		curl -sSL https://dot.net/v1/dotnet-install.sh -o /tmp/dotnet-install.sh &&
		chmod +x /tmp/dotnet-install.sh &&
		sudo /tmp/dotnet-install.sh --install-dir /usr/share/dotnet -channel STS -version latest &&
		return "$OK"
}
