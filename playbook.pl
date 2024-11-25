#!/usr/bin/env perl

# Playbook =============================================================== {{{
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
    [ 'git@github.com:brenopacheco/.dotfiles.git',            '~/.dotfiles'         ],
    [ 'git@github.com:brenopacheco/.password-store.git',      '~/.password-store'   ],
    [ 'git@github.com:brenopacheco/notes.git',                '~/notes'             ],
    [ 'git@github.com:brenopacheco/dwm-fork.git',             '~/git/dwm-fork'      ],
    [ 'git@github.com:brenopacheco/st-fork.git',              '~/git/st-fork'       ],
    [ 'git@github.com:brenopacheco/dmenu-fork.git',           '~/git/dmenu-fork'    ],
    [ 'git@github.com:brenopacheco/slstatus-fork.git',        '~/git/slstatus-fork' ],
    [ 'https://github.com/asdf-vm/asdf.git --branch v0.14.1', '~/.asdf'             ]
);

asdf(
    nodejs => {
        url => "https://github.com/twuni/asdf-yarn.git",
        versions => [ "23.3.0", "22.11.0", "21.7.3", "20.18.1", "19.9.0", "18.20.5" ],
        global => "23.3.0"
    },
    yarn => {
        url => "https://github.com/twuni/asdf-yarn.git",
        versions => [ "1.20.0" ],
        global => "1.20.0"
    }
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

stow(cwd => '~/.dotfiles', target => '~/', package => 'home');

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
    root => [ 'bluetooth', 'cronie', 'docker', 'lightdm', 'sshd' ],
    user => [ 'gpg-agent.target' ]
);

makepkg(
    'makepkg/fork' => [
        'dmenu-fork',
        'dwm-fork',
        'slstatus-fork',
        'st-fork',
        'neovim'
    ],
    'makepkg/aur'  => [
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

# }}} ------------------------------------------------------------------------
# Library ================================================================ {{{
use diagnostics;
use feature 'say';

sub _system {
    my ($shout, $cmd) = @_;
    my @out = `$cmd 2>&1`;
    if ($shout) {
        print "  | $_" for (@out);
    }
    if ($? != 0) {
        print STDERR "\n[ERROR] command failed: $cmd\n";
        exit 1;
    }
    return @out;
}

sub configure {
    my (%cfg) = @_;
    say "[OK] configuring";
    # say "  * host: $cfg{host}";
    # say "  * user: $cfg{user}";
    # say "  * root: $cfg{root}";
}

# TODO: what do we want to ensure?
# 1. file exists (copy as is if not exist)
# 2. lines are in included in the file
# 3. respect original file ownership and permissions
sub ensure {
    say "[TODO] ensure";
}

sub clone {
    my @res = grep { `file -E ${$_}[1]\n` and $? != 0 } @_;
    if (!@res) {
        return say "[OK] clone"
    }
    say "[-] clone";
    my $mlen = (sort { $b <=> $a } map { length(${$_}[0]) } @res)[0];
    for (@res) {
        my ($repo, $dir) = (@{$_});
        printf "  * cloning: %-${mlen}s -> %s\n", $repo, $dir;
        _system(1, "git clone $repo $dir");
    }
}

sub stow {
    my (%cfg) = @_;
    my $args = "--adopt -v 2 -d $cfg{cwd} -t $cfg{target} $cfg{package}";
    my @links = grep { /^LINK/g } _system(0, "stow -n $args 2>&1");
    if (!@links) {
        return say "[OK] stow";
    }
    say "[-] stow";
    say "  * stowing: $cfg{cwd}/$cfg{package} => $cfg{target}";
    _system(1, "stow $args 2>&1 | grep 'LINK'");
}

sub asdf {
    say "[TODO] asdf";
}

sub pacman {
    my $res = `pacman -Q @_ 2>&1`;
    if ($? == 0) {
        return say "[OK] pacman";
    }
    my @packages = $res =~ /error: package '(.*)' was not found/g;
    say "[-] pacman";
    for my $package (@packages) {
        say "  * installing: $package" ;
        _system(1, "sudo pacman -S --noconfirm --needed $package");
    }
}

sub dirs {
    say "[TODO] dirs";
}

sub systemctl {
    say "[TODO] systemctl";
}

# etc will scp all files in sync to a temporary dir, change permissions to
# root, and check file by file if they are the same in the target system,
# copying the file if they are not. files will be owned by root and
# permissions are kept
sub etc {
    say "[TODO] etc";
}

sub makepkg {
    say "[TODO] makepkg";
}

sub node {
    say "[TODO] node";
}

sub go {
    say "[TODO] go";
}

# }}} ------------------------------------------------------------------------
