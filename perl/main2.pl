#!/usr/bin/env perl

use diagnostics;
use feature 'say';

# use const USER => $ENV{'USER'};
# use const ROOT => 'root';
# use const HOST => 'localhost';

# Playbook ===================================================================
configure (
    host => 'localhost',
    root => 'root',
    user => $ENV{'USER'}
);

ensure(
    [ 'files/known_hosts', '~/.ssh/known_hosts' ]
)

clone(
    [ 'git@github.com:brenopacheco/.dotfiles.git',      '~/.dotfiles'         ],
    [ 'git@github.com:brenopacheco/.password-store.git','~/.password-store'   ],
    [ 'git@github.com:brenopacheco/notes.git',          '~/notes'             ],
    [ 'git@github.com:brenopacheco/dwm-fork.git',       '~/git/dwm-fork'      ],
    [ 'git@github.com:brenopacheco/st-fork.git',        '~/git/st-fork'       ],
    [ 'git@github.com:brenopacheco/dmenu-fork.git',     '~/git/dmenu-fork'    ],
    [ 'git@github.com:brenopacheco/slstatus-fork.git',  '~/git/slstatus-fork' ]
);

clone(
    ['https://github.com/asdf-vm/asdf.git --branch v0.14.1', '~/.asdf' ]
);

pacman (
    'arandr', 'base', 'base-devel', 'bash-completion', 'bat', 'bear',
    'blueman', 'bluez', 'bluez-utils', 'bottom', 'chromium', 'cmake', 'conky',
    'ctags', 'dosfstools', 'dunst', 'dzen2', 'fd', 'feh', 'file-roller',
    'firefox', 'fzf', 'git', 'gparted', 'gpick', 'gtk2', 'gtk3', 'gtk4',
    'gvim', 'htop', 'imagemagick', 'inotify-tools', 'jq', 'lightdm',
    'lightdm-gtk-greeter', 'lldb', 'lsof', 'man-db', 'moreutils', 'ncdu',
    'net-tools', 'network-manager-applet', 'ninja', 'pamixer', 'parted',
    'pass', 'pass-otp', 'pasystray', 'pavucontrol', 'pdftk', 'perl',
    'perl-tidy', 'redshift', 'renameutils', 'ripgrep', 'rsync', 'screengrab',
    'sqlitebrowser', 'stow', 'sxiv', 'tmux', 'tree', 'udiskie', 'unrar',
    'unzip', 'usbutils', 'v4l2loopback-dkms', 'wget', 'wmctrl', 'xarchiver',
    'xclip', 'xdotool', 'xorg-server-xephyr', 'xorg-xev', 'xorg-xkill',
    'xorg-xlsclients', 'xorg-xmodmap', 'xorg-xsetroot', 'xorg-xwininfo',
    'zathura', 'zathura-pdf-mupdf', 'zip', 'zk'
);

makepkg(
    dir => 'makepkg/fork',
    pkg => ['dmenu-fork', 'dwm-fork', 'slstatus-fork', 'st-fork', 'neovim']
);

makepkg(
    dir => 'makepkg/aur',
    pkg => ['bun', 'helm-ls', 'lls-addons', 'marksman', 'obs-backgroundremoval',
    'rose-pine-gtk-theme-full', 'slack-desktop', 'vscode-js-debug',
    'xcursor-breeze', 'zoom']
);

etc(
    ['etc/lightdm.conf',   '/etc/lightdm/lightdm-gtk-greeter.conf'],
    ['etc/monitor.conf',   '/etc/X11/xorg.conf.d/10-monitor.conf'],
    ['etc/touchpad.conf',  '/etc/X11/xorg.conf.d/30-touchpad.conf'],
    ['etc/keyboard.rules', '/etc/udev/rules.d/50-keyboard.rules'],
    ['etc/wacom.rules',    '/etc/udev/rules.d/99-wacom.rules'],
);

# ['etc/crontab',        '/var/spool/cron/breno'] # not var necessarily

stow(cwd => '~/.dotfile', target => '~/', package => 'home');

systemctl('root', ['sshd', 'cronie']);
systemctl('user', ['gpg-agent']);

node (
	['16', '18', '19', '20', '21'],
	'bash-language-server',
	'eslint',
	'prettier',
	'prettierd',
	'typescript',
	'typescript-language-server',
	'vim-language-server',
	'vscode-langservers-extracted'
);

go(
	'github.com/gokcehan/lf@latest',
	'github.com/jesseduffield/lazydocker@latest',
	'github.com/mattn/efm-langserver@latest',
	'github.com/mikefarah/yq/v4@latest',
	'github.com/wader/jq-lsp@latest',
	'golang.org/x/tools/cmd/godoc@latest',
	'golang.org/x/tools/gopls@latest',
	'mvdan.cc/sh/v3/cmd/shfmt@latest',
	'sigs.k8s.io/kind@v0.20.0'
);

# Library ===================================================================
sub configure {
	say "Configuring";
}

sub clone {
	foreach (@_) {
		my ($dir, $repo) = (@{$_});
		say "Cloning ", $repo, "into $dir";
	}
}

sub pacman {
	say "Installing (pacman) @_";
}

sub makepkg {
	say "Installing (makepkg) @_";
}

# stow -n --adopt -v 2 -t $HOME/ home 2>&1
sub stow {
	say "Stowing";
}

sub systemctl {
	my ($who, $services) = @_;
	for (@{$services}) {
		say "Configuring service $_ ($who)";
	}
}

# etc will scp all files in sync to a temporary dir, change permissions to
# root, and check file by file if they are the same in the target system,
# copying the file if they are not
sub etc {
	for (@_) {
		my ($file, $target) = @{$_};
		say "Syncing $file to $target";
	}
}

sub node {
	say "Node install";
}

sub go {
	say "Go install";
}

# TODO: want to ensure:
# 1. file exists
# 2. lines are in included in the file
sub ensure {
	say "Ensure";
}
