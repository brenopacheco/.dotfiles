#!/usr/bin/env perl

use diagnostics;
use feature 'say';

# Playbook ===================================================================
configure (
    host => 'localhost',
    root => 'root',
    user => $ENV{'USER'}
);

ensure(
    [ 'misc/known_hosts', '~/.ssh/known_hosts'    ],
    [ 'misc/crontab',     '/var/spool/cron/breno' ]
);

clone(
    [ 'git@github.com:brenopacheco/.dotfiles.git',       '~/.dotfiles'         ],
    [ 'git@github.com:brenopacheco/.password-store.git', '~/.password-store'   ],
    [ 'git@github.com:brenopacheco/notes.git',           '~/notes'             ],
    [ 'git@github.com:brenopacheco/dwm-fork.git',        '~/git/dwm-fork'      ],
    [ 'git@github.com:brenopacheco/st-fork.git',         '~/git/st-fork'       ],
    [ 'git@github.com:brenopacheco/dmenu-fork.git',      '~/git/dmenu-fork'    ],
    [ 'git@github.com:brenopacheco/slstatus-fork.git',   '~/git/slstatus-fork' ]
);

clone(
    ['https://github.com/asdf-vm/asdf.git --branch v0.14.1', '~/.asdf' ]
);

asdf(
    plugin => "nodejs",
    url => "https://github.com/twuni/asdf-yarn.git",
    versions => [ "23.3.0", "22.11.0", "21.7.3", "20.18.1", "19.9.0", "18.20.5" ],
    global => "23.3.0"
);

asdf(
    plugin => "yarn",
    url => "https://github.com/twuni/asdf-yarn.git",
    versions => [ "1.20.0" ],
    global => "1.20.0"
);

pacman(
    'arandr', 'base', 'base-devel', 'bash-completion', 'bat', 'bear',
    'blueman', 'bluez', 'bluez-utils', 'bottom', 'chromium', 'clang', 'cmake',
    'conky', 'cronie', 'ctags', 'dosfstools', 'dunst', 'dzen2', 'fd', 'feh',
    'file-roller', 'firefox', 'fzf', 'git', 'gnome-backgrounds', 'go',
    'gparted', 'gpick', 'gtk2', 'gtk3', 'gtk4', 'gvim', 'helm', 'htop',
    'imagemagick', 'inotify-tools', 'jq', 'k9s', 'lightdm',
    'lightdm-gtk-greeter', 'lldb', 'lsof', 'lua', 'lua51', 'lua52', 'lua53',
    'luajit', 'lua-language-server', 'luarocks', 'man-db', 'moreutils',
    'ncdu', 'net-tools', 'network-manager-applet', 'ninja',
    'otf-comicshanns-nerd', 'pamixer', 'parted', 'pass', 'pass-otp',
    'pasystray', 'pavucontrol', 'pdftk', 'perl', 'perl-tidy', 'python',
    'python-pipx', 'redshift', 'renameutils', 'ripgrep', 'rsync', 'rust',
    'screengrab', 'shellcheck', 'shfmt', 'sqlitebrowser', 'stow', 'stylua',
    'sxiv', 'tmux', 'tree', 'ttf-3270-nerd', 'ttf-firacode-nerd', 'udiskie',
    'unrar', 'unzip', 'usbutils', 'v4l2loopback-dkms', 'wget', 'wmctrl',
    'xarchiver', 'xclip', 'xdotool', 'xorg-server-xephyr', 'xorg-xev',
    'xorg-xkill', 'xorg-xlsclients', 'xorg-xmodmap', 'xorg-xsetroot',
    'xorg-xwininfo', 'zathura', 'zathura-pdf-mupdf', 'zip', 'zk'
);

# TODO: change cwd, move ~/.dotfile/files/home to ~/.dotfile/files
stow(cwd => '~/.dotfile/files', target => '~/', package => 'home');

dirs('git', 'sketch', 'tmp');

etc(
    { file => 'etc/lightdm-gtk-greeter.conf', dir => '/etc/lightdm/'         },
    { file => 'etc/10-keyboard.rules',        dir => '/etc/udev/rules.d/'    },
    { file => 'etc/40-wacom.rules',           dir => '/etc/udev/rules.d/'    },
    { file => 'etc/10-keyboard.conf',         dir => '/etc/X11/xorg.conf.d/' },
    { file => 'etc/20-monitor.conf',          dir => '/etc/X11/xorg.conf.d/' },
    { file => 'etc/30-touchpad.conf',         dir => '/etc/X11/xorg.conf.d/' },
);

systemctl(
    who => 'root',
    svc => [ 'bluetooth', 'cronie', 'docker', 'lightdm', 'sshd' ]
);

systemctl(
    who => 'user',
    svc => [ 'gpg-agent.target' ]
);

makepkg(
    dir => 'makepkg/fork',
    pkg => ['dmenu-fork', 'dwm-fork', 'slstatus-fork', 'st-fork', 'neovim']
);

makepkg(
    dir => 'makepkg/aur',
    pkg => [
        'bun',
        'helm-ls',
        'lls-addons',
        'marksman',
        'obs-backgroundremoval',
        'rose-pine-gtk-theme-full',
        'slack-desktop',
        'vscode-js-debug',
        'xcursor-breeze',
        'zoom'
    ]
);

node(
    [ 'bash-language-server',              'bash-language-server'              ],
    [ 'eslint',                            'eslint'                            ],
    [ 'prettier',                          'prettier'                          ],
    [ 'prettierd',                         '@fsouza/prettierd'                 ],
    [ 'tsc',                               'typescript'                        ],
    [ 'tsserver',                          'typescript-language-server'        ],
    [ 'vim-language-server',               'vim-language-server'               ],
    [ 'yaml-language-server',              'yaml-language-server'              ],
    [ 'vscode-eslint-language-server',     'vscode-langservers-extracted'      ],
    [ 'docker-langserver',                 'dockerfile-language-server-nodejs' ]
);

go(
    [ 'efmls',      'github.com/mattn/efm-langserver@latest'     ],
    [ 'godoc',      'golang.org/x/tools/cmd/godoc@latest'        ],
    [ 'gopls',      'golang.org/x/tools/gopls@latest'            ],
    [ 'kind',       'sigs.k8s.io/kind@v0.20.0'                   ],
    [ 'lazydocker', 'github.com/jesseduffield/lazydocker@latest' ],
    [ 'lf',         'github.com/gokcehan/lf@latest'              ],
    [ 'shfmt',      'mvdan.cc/sh/v3/cmd/shfmt@latest'            ],
    [ 'yq',         'github.com/mikefarah/yq/v4@latest'          ]
);

# Library ===================================================================
sub configure {
    say "Configuring";
}

# TODO: what do we want to ensure?
# 1. file exists (copy as is if not exist)
# 2. lines are in included in the file
# 3. respect original file ownership and permissions
sub ensure {
    say "ensure";
}

sub clone {
    say "clone";
    # foreach (@_) {
    #     my ($dir, $repo) = (@{$_});
    #     say "Cloning ", $repo, "into $dir";
    # }
}

sub asdf {
    say "asdf";
}

sub pacman {
    say "pacman";
    # say "Installing (pacman) @_";
}

# stow -n --adopt -v 2 -t $HOME/ home 2>&1
sub stow {
    say "stowing";
}

sub dirs {
    say "mkdir";
}

sub systemctl {
    say "systemctl";
    # my ($who, $services) = @_;
    # for (@{$services}) {
    #     say "Configuring service $_ ($who)";
    # }
}

# etc will scp all files in sync to a temporary dir, change permissions to
# root, and check file by file if they are the same in the target system,
# copying the file if they are not. files will be owned by root and
# permissions are kept
sub etc {
    say "etc";
    # for (@_) {
    #     my ($file, $target) = @{$_};
    #     say "Syncing $file to $target";
    # }
}

sub makepkg {
    say "makepkg";
    # say "Installing (makepkg) @_";
}

sub node {
    say "node";
}

sub go {
    say "go";
}
