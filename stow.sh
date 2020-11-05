#!/bin/bash

cd $HOME/.dotfiles
for package in $(ls -d -- */); do
	echo "STOWING PACKAGE: $package"
	stow -Rv $package
	echo ""
done
