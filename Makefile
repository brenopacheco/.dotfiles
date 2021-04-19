.PHONY: all install pass unstow stow help
.ONESHELL


help:
	@echo "stow    :: stow files"
	@echo "unstow  :: remove symlinks"
	@echo "pass    :: restore passwords"
	@echo "install :: install packages"
	@echo "all     :: install, pass, stow"

stow:
	@echo "adding symlinks"
	stow files

unstow:
	@echo "removing symlinks"
	stow --delete files

pass:
	@echo "restoring passwords"
	./passwords

install:
	@echo "installing packages"
	./install

all: install pass stow
