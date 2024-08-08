#!/bin/bash

email=$(git config --local --get user.email)

if [ -z "$email" ]; then
	email=$(git config --global --get user.email)
	if [ -z "$email" ]; then
		echo "netrc: no local or global email is set in .git/config" >&2
		exit 1
	fi
fi

if ~/.config/git/switch-netrc.sh "$email"; then
	exec /usr/share/git/credential/netrc/git-credential-netrc.perl "$@"
fi

echo "netrc: configuration not found for $email" >&2
echo "netrc: create ~/.netrc.gpg-<email> or run git config --local user.email <email>" >&2
exit 1
