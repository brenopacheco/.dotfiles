#!/bin/bash

# cat fonts | xargs -i kitty --debug-font-fallback -o font_family="{}" bash -c "read -p \"font: {}\""
exec 1> ./out.log 2>&1

# kitty + list-fonts
# font-manager
# font-ls


tmp=$(mktemp)
cat<<EOF > $tmp
abcdefghijklmnopqrstuvwxyz
ABCDEFGHIJKLMNOPQRSTUVWXYZ
0 1 2 3 4 5 6 7 8 9 {[(...=> <= << >> ==> !@#$%&/"´`''`")]}
EOF

while read p; do
	text=$(cat $tmp)
	kitty  --debug-font-fallback -o font_family="$p" bash -c "cat $tmp; read -p \"$p\"" &
done < fonts

