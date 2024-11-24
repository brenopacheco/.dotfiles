#!/bin/bash

IS_CLONNING=0

pid=$PPID
while [[ "$pid" -ne 1 ]]; do
	parent_command=$(ps -o command= --pid "$pid")
	if echo "$parent_command" | grep -q "git clone"; then
		IS_CLONNING=1
	fi
	pid=$(ps -o ppid= --pid "$pid" | tr -d ' ')
done

if [[ "$IS_CLONNING" -eq 1 ]]; then
	exec /usr/share/git/credential/netrc/git-credential-netrc.perl "$@"
fi

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
