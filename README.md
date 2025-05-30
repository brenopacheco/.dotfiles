# Dotfiles Playbook

This repository contains a comprehensive, Perl-based playbook for automating the setup and configuration of a Linux (Arch-based) development environment. It manages package installation, dotfile deployment, system configuration, user directories, custom packages, and more.

## Features

- **Automated package installation** via `pacman` (official and custom packages)
- **Dotfile management** using GNU Stow
- **System configuration**: `/etc` files, systemd services, and more
- **Language runtimes and tools**: Node.js, Yarn, Go, etc. (via asdf, go install, npm)
- **Custom package building** using makepkg and local repositories
- **GPG key management**
- **Git repository cloning** for dotfiles, notes, pass, and custom software
- **Idempotent and debug-friendly**: safe to re-run, with debug output

## Directory Structure

- `playbook.pl` — Perl script that orchestrates all tasks.
- `Makefile` — Simple wrapper to run the playbook.
- `etc/` — System configuration files to be copied to `/etc`, `/etc/udev/rules.d/`, etc.
- `home/` — User dotfiles and configuration (to be stowed into `$HOME`).
- `makepkg/` — Custom and AUR package build scripts.
  - `fork/` — Custom/forked package sources (e.g., `dwm`, `st`, etc.).
  - `aur/` — AUR package build scripts.
- Other directories (e.g., `.config/`, `bin/`) under `home/` for user-level configuration.

## Requirements

- **Perl** (with standard modules)
- **git**
- **pacman** (Arch Linux)
- **GPG** (for key management)
- **Systemd** (for service management)
- SSH access to the target host - user and root (even on localhost)

## Usage

1. **Clone this repository:**
   ```sh
   git clone git@github.com:brenopacheco/.dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

2. **Run the playbook:**
   ```sh
   make
   ```
   Or directly:
   ```sh
   perl ./playbook.pl
   ```

   - You can set environment variables to control the run:
     - `USER` — Target username (default: current user)
     - `HOST` — Target host (default: localhost)
     - `DEBUG` — Set to any value for debug output

3. **What it does:**
   - Installs missing packages
   - Sets up user directories
   - Deploys dotfiles and system configuration
   - Clones and updates git repositories
   - Builds and installs custom packages
   - Ensures systemd services are enabled and started
   - Installs language runtimes and tools

## Customization

- **Add or remove packages** in the `pacman(...)` section of `playbook.pl`.
- **Edit dotfiles** in the `home/` directory.
- **Add system configuration** in the `etc/` directory.
- **Add custom packages** in `makepkg/fork/` or `makepkg/aur/`.

## Notes

- The playbook is designed to be idempotent: you can safely re-run it.
- Some steps (e.g., GPG key import) may require manual intervention if keys are missing.
- For remote hosts, ensure SSH access and sudo privileges.

## License

MIT License (or your preferred license) 