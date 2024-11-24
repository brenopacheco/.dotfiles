#!/bin/bash

email="$1"

if [ -z "$email" ]; then
	echo "netrc: no email is set. using global" >&2
	email=$(git config --local --get user.email)
fi

netrc_email=$(gpg -d ~/.netrc.gpg 2>/dev/null | grep login | head -n 1 | sed 's/^\s\+login\s\+//')

if [[ "$email" == "$netrc_email" ]]; then
	exit 0
fi

for file in $(fd ".netrc.gpg-" -H -d 1 ~/); do
	if gpg -d "$file" 2>/dev/null | grep -e "^\s\+login\s\+$email" &>/dev/null; then
		rm ~/.netrc.gpg
		ln -sn "$file" ~/.netrc.gpg
		notify-send "netrc-helper" "$email\n ->$(basename "$file")"
		exit 0
	fi
done

exit 1
