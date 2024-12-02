#!/usr/bin/env perl

# TODO:
# 1. [ ] complete subs
#   - [ ] etc
#   - [ ] ensure
#   - [ ] makepkg
# 2. [ ] complete ensure sub
# 3. [ ] make _system use ssh connection

# Playbook =============================================================== {{{
configure(
    host  => 'localhost',
    root  => 'root',
    user  => $ENV{'USER'},
    debug => 0,
    ssh   => 0
);

# ensure(
#     [ 'misc/known_hosts', '~/.ssh/known_hosts'    ],
#     [ 'misc/crontab',     '/var/spool/cron/breno' ]
# );

git(
    [ 'git@github.com:brenopacheco/.dotfiles.git',       '~/.dotfiles' ],
    [ 'git@github.com:brenopacheco/.password-store.git', '~/.password-store' ],
    [ 'git@github.com:brenopacheco/notes.git',           '~/notes' ],
    [ 'git@github.com:brenopacheco/dwm-fork.git',        '~/git/dwm-fork' ],
    [ 'git@github.com:brenopacheco/st-fork.git',         '~/git/st-fork' ],
    [ 'git@github.com:brenopacheco/dmenu-fork.git',      '~/git/dmenu-fork' ],
    [ 'git@github.com:brenopacheco/slstatus-fork.git', '~/git/slstatus-fork' ],
    [ 'https://github.com/asdf-vm/asdf.git --branch v0.14.1', '~/.asdf' ]
);

asdf(
    {
        plugin   => "nodejs",
        url      => "https://github.com/asdf-vm/asdf-nodejs.git",
        versions => ["23.3.0"],
        global   => "23.3.0"
    },
    {
        plugin   => "yarn",
        url      => "https://github.com/twuni/asdf-yarn.git",
        versions => ["1.20.0"],
        global   => "1.20.0"
    }
);

pacman(
    'arandr',                 'base',
    'base-devel',             'bash-completion',
    'bat',                    'bear',
    'blueman',                'bluez',
    'bluez-utils',            'bottom',
    'chromium',               'clang',
    'cmake',                  'conky',
    'cronie',                 'ctags',
    'dosfstools',             'dunst',
    'dzen2',                  'fd',
    'feh',                    'file-roller',
    'firefox',                'fzf',
    'git',                    'gnome-backgrounds',
    'go',                     'gopls',
    'gparted',                'gpick',
    'gtk2',                   'gtk3',
    'gtk4',                   'gvim',
    'helm',                   'htop',
    'imagemagick',            'inotify-tools',
    'jq',                     'k9s',
    'lightdm',                'lightdm-gtk-greeter',
    'lf',                     'lldb',
    'lsof',                   'lua',
    'lua51',                  'lua52',
    'lua53',                  'luajit',
    'lua-language-server',    'luarocks',
    'man-db',                 'moreutils',
    'ncdu',                   'net-tools',
    'network-manager-applet', 'ninja',
    'otf-comicshanns-nerd',   'pamixer',
    'parted',                 'pass',
    'pass-otp',               'pasystray',
    'pavucontrol',            'pdftk',
    'perl',                   'perl-tidy',
    'python',                 'python-pipx',
    'redshift',               'renameutils',
    'ripgrep',                'rsync',
    'rust',                   'screengrab',
    'shellcheck',             'shfmt',
    'sqlitebrowser',          'stow',
    'stylua',                 'sxiv',
    'tmux',                   'tree',
    'ttf-3270-nerd',          'ttf-firacode-nerd',
    'udiskie',                'unrar',
    'unzip',                  'usbutils',
    'v4l2loopback-dkms',      'wget',
    'wmctrl',                 'xarchiver',
    'xclip',                  'xdotool',
    'xorg-server-xephyr',     'xorg-xev',
    'xorg-xkill',             'xorg-xlsclients',
    'xorg-xmodmap',           'xorg-xsetroot',
    'xorg-xwininfo',          'zathura',
    'zathura-pdf-mupdf',      'zip',
    'zk'
);

stow( cwd => '~/.dotfiles', target => '~/', package => 'home' );

dirs( '~/git', '~/sketch', '~/tmp' );

# etc(
#     { file => 'etc/lightdm-gtk-greeter.conf', dir => '/etc/lightdm/'         },
#     { file => 'etc/10-keyboard.rules',        dir => '/etc/udev/rules.d/'    },
#     { file => 'etc/40-wacom.rules',           dir => '/etc/udev/rules.d/'    },
#     { file => 'etc/10-keyboard.conf',         dir => '/etc/X11/xorg.conf.d/' },
#     { file => 'etc/20-monitor.conf',          dir => '/etc/X11/xorg.conf.d/' },
#     { file => 'etc/30-touchpad.conf',         dir => '/etc/X11/xorg.conf.d/' },
# );

# systemctl(
#     user => [ 'gpg-agent.target' ],
#     root => [
#         'bluetooth.service',
#         'cronie.service',
#         'docker.service',
#         'lightdm.service',
#         'sshd.service'
#      ]
# );

systemctl(
    user => ['gpg-agent.target'],
    root => [
        'bluetooth.service', 'cronie.service',
        'docker.service',    'lightdm.service',
        'sshd.service'
    ]
);

makepkg(
    'makepkg/fork/dmenu-fork',
    'makepkg/fork/dwm-fork',
    'makepkg/fork/slstatus-fork',
    'makepkg/fork/st-fork',

    # 'makepkg/fork/neovim',
    'makepkg/aur/bun',

    # 'makepkg/aur/helm-ls',
    # 'makepkg/aur/lls-addons',
    # 'makepkg/aur/marksman',
    # 'makepkg/aur/obs-backgroundremoval',
    # 'makepkg/aur/rose-pine-gtk-theme-full',
    # 'makepkg/aur/slack-desktop',
    # 'makepkg/aur/vscode-js-debug',
    # 'makepkg/aur/xcursor-breeze',
    # 'makepkg/aur/zoom'
);

node(
    [ 'bash-language-server',          'bash-language-server' ],
    [ 'eslint',                        'eslint' ],
    [ 'prettier',                      'prettier' ],
    [ 'prettierd',                     '@fsouza/prettierd' ],
    [ 'tsc',                           'typescript' ],
    [ 'tsserver',                      'typescript-language-server' ],
    [ 'vim-language-server',           'vim-language-server' ],
    [ 'yaml-language-server',          'yaml-language-server' ],
    [ 'vscode-eslint-language-server', 'vscode-langservers-extracted' ],
    [ 'docker-langserver',             'dockerfile-language-server-nodejs' ]
);

go(
    [ 'efm-langserver', 'github.com/mattn/efm-langserver@latest' ],
    [ 'godoc',          'golang.org/x/tools/cmd/godoc@latest' ],
    [ 'kind',           'sigs.k8s.io/kind@v0.20.0' ],
    [ 'lazydocker',     'github.com/jesseduffield/lazydocker@latest' ],
    [ 'yq',             'github.com/mikefarah/yq/v4@latest' ]
);

# }}} ------------------------------------------------------------------------
# Library ================================================================ {{{
use diagnostics;
use feature 'say';

my %cfg = ();

sub _task {
    my ($cmd) = @_;
    if ( $cfg{ssh} ) {
        $cmd =~ s/'/'\\''/g;
        $cmd = "ssh $cfg{user}\@$cfg{host} '$cmd'";
    }
    if ( $cfg{debug} ) {
        say "[DEBUG]: $cmd";
    }
    my @out = `$cmd 2>&1`;
    print "  | $_" for (@out);
    if ( $? != 0 ) {
        print STDERR "\n[ERROR] command failed: $cmd\n";
        exit 1;
    }
}

sub _check {
    my ($cmd) = @_;
    if ( $cfg{ssh} ) {
        $cmd =~ s/'/'\\''/g;
        $cmd = "ssh $cfg{user}\@$cfg{host} '$cmd'";
    }
    if ( $cfg{debug} ) {
        say "[DEBUG]: $cmd";
    }
    my $out = `$cmd 2>&1`;
    if ( $out =~ /ssh: Could not resolve hostname/ ) {
        die "Error: $out";
    }
    return { ok => $? == 0, out => $out };
}

sub configure {
    my (%settings) = @_;
    $cfg{user}  = $settings{user};
    $cfg{root}  = $settings{root};
    $cfg{host}  = $settings{host};
    $cfg{debug} = $settings{debug};
    $cfg{ssh}   = $settings{ssh};
}

sub git {
    my @in   = @_;
    my $dirs = join( " ", map { ${$_}[1] } @in );
    my $out  = _check("file -E $dirs")->{out};
    my @res  = $out =~ /^(.*):\s+ERROR: cannot stat/mg;
    if ( !@res ) {
        return say "[OK] git";
    }
    say "[-] git";
    my $mlen = ( sort { $b <=> $a } map { length( ${$_}[0] ) } @in )[0];
    for my $dir (@res) {
        my ($entry) = grep { $dir eq ${$_}[1] =~ s/~/\/home\/$cfg{user}/r } @in;
        my ( $repo, $dir ) = @{$entry};
        printf "  * cloning: %-${mlen}s -> %s\n", $repo, $dir;
        _task("git clone $repo $dir");
    }
}

sub stow {
    my (%cfg) = @_;
    my $args  = "--adopt -v 2 -d $cfg{cwd} -t $cfg{target} $cfg{package}";
    my @links = grep { /^LINK/g } _check("stow -n $args");
    if ( !@links ) {
        return say "[OK] stow";
    }
    say "[-] stow";
    say "  * stowing: $cfg{cwd}/$cfg{package} => $cfg{target}";
    _task("stow $args 2>&1 | grep 'LINK'");
}

sub asdf {
    my $load  = 'source ~/.asdf/asdf.sh;';
    my @tasks = ();
    for my $conf (@_) {
        my $check     = _check("$load asdf list $conf->{plugin}");
        my $installed = $check->{ok};
        my %versions =
          map { $_ => 1 } $installed ? $check->{out} =~ /([^*\s]+)/mg : ();
        my @missing = grep { !exists $versions{$_} } @{ $conf->{versions} };
        my $current = $1 if $check->{out} =~ /\*(\S+)/;
        if ( !$installed ) {
            push @tasks, sub {
                say "  * installing: $conf->{plugin} => $conf->{url}";
                _task("$load asdf plugin add $conf->{plugin} $conf->{url}");
            };
        }
        for my $version (@missing) {
            push @tasks, sub {
                say "  * installing: $conf->{plugin} => $version";
                _task("$load asdf install $conf->{plugin} $version");
            };
        }
        if ( !$current || $current ne $conf->{global} ) {
            push @tasks, sub {
                say "  * set-global: $conf->{plugin} => $conf->{global}";
                _task("$load asdf global $conf->{plugin} $conf->{global}");
            };
        }
    }
    if ( !@tasks ) {
        return say "[OK] asdf";
    }
    say "[-] asdf";
    $_->() for @tasks;
}

sub pacman {
    my $res = _check("pacman -Q @_");
    if ( $res->{ok} ) {
        return say "[OK] pacman";
    }
    my @packages = $res->{out} =~ /^error: package '(.*)' was not found/mg;
    if ( !@packages ) {
        return say "[OK] pacman";
    }
    say "[-] pacman";
    say "  * installing: ", join( ', ', @packages );
    _task("sudo pacman -S --noconfirm --needed @packages");
}

sub dirs {
    my $dirs = join( " ", @_ );
    my $out  = _check("file -E $dirs")->{out};
    my @res  = $out =~ /^(.*):\s+ERROR: cannot stat/mg;
    if ( !@res ) {
        return say "[OK] dirs";
    }
    say "[-] dirs";
    for my $dir (@res) {
        say "  * mkdir: $dir";
        _task("mkdir $dir");
    }
}

sub systemctl {
    my (%cfg) = @_;
    my @tasks = ();

    sub _service_status {
        my ( $services, $user_flag ) = @_;
        return () unless @$services;
        my $cmd_prefix = $user_flag ? "systemctl --user" : "systemctl";
        my @enabled =
          split( "\n", _check("$cmd_prefix is-enabled @$services")->{out} );
        my @active =
          split( "\n", _check("$cmd_prefix is-active @$services")->{out} );
        return map {
            $services->[$_] => {
                who     => $user_flag ? 'user' : 'root',
                enabled => $enabled[$_],
                active  => $active[$_]
            }
        } 0 .. $#$services;
    }
    my %root_status = _service_status( $cfg{root}, 0 );
    my %user_status = _service_status( $cfg{user}, 1 );
    my %status      = ( %root_status, %user_status );
    while ( my ( $service, $status ) = each %status ) {
        die "Unit not found: $service" if $status->{enabled} =~ /not-found/;
        my $cmd_prefix =
          $status->{who} eq 'user' ? "systemctl --user" : "sudo systemctl";
        push @tasks, sub {
            say "  * enable [$status->{who}]: $service";
            _task("$cmd_prefix enable $service");
          }
          if $status->{enabled} =~ /disabled/;
        push @tasks, sub {
            say "  * start  [$status->{who}]: $service";
            _task("$cmd_prefix start $service");
          }
          if $status->{active} =~ /inactive/;
    }
    if ( !@tasks ) {
        return say "[OK] systemctl";
    }
    say "[-] systemctl";
    $_->() for @tasks;
}

# TODO: what do we want to ensure?
# 1. file exists (copy as is if not exist)
# 2. lines are in included in the file
# 3. respect original file ownership and permissions
sub ensure {
    say "[TODO] ensure";
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

    sub _prepare {
        my @dirs = @_;
        my @pkgs = map { $& if /[^\/]+$/ } @dirs;
        my %info = map {
            my $dir      = $dirs[$_];
            my $pkg      = $pkgs[$_];
            my $PKGBUILD = "$dir/PKGBUILD";
            my $pkgver = $1 if `grep -m1 "pkgver=" $PKGBUILD` =~ /pkgver=(\S+)/;
            my $pkgrel = $1 if `grep -m1 "pkgrel=" $PKGBUILD` =~ /pkgrel=(\S+)/;
            my $version = $pkgver . "-" . $pkgrel;
            $pkg => { dir => $dir, version => $version, vercmp => 1 };
        } 0 .. $#pkgs;
        my @installs = split( "\n", _check("pacman -Q @pkgs 2>&1")->{out} );
        for (@installs) {
            next if /^error: package '(.*)' was not found/;
            my ( $pkg, $installed ) = ( $1, $2 ) if /([\w-]+)\s(.+)/;
            next if ( !defined $pkg ) or ( !defined $installed );
            $info{$pkg}{installed} = $installed;
            $info{$pkg}{vercmp}    = `vercmp $info{$pkg}{version} $installed`;
        }
        return %info;
    }

    sub _install {

# TODO:
# my ($src, $dst) = ("files/makepkg/$pkgver", "/tmp/$pkgver")
# my $buildcmd = "
#     makepkg -scCf -d /tmp/makepkg/$pkgver &&
#     cp /tmp/makepkg/$pkgver/*.pkg.tar.zst /usr/share/pacman/ &&
#     repo-add --new /usr/share/pacman/*.db.tar.zst /usr/share/pacman/*.pkg.tar.zst
# ";
# push @commands, {
#     name => "Build custom package $pkgname",
#     shell => [
#         sub { Lib::scp($src, $dst)}
#         sub { Lib::ssh($buildcmd) }
#     }
# }
# my $dir = # tmp dir
# scp files/pacman/$pkg localhost:$dir
# ssh localhost makepkg -scCf $dir
# my $pkgfile = "$pkg-$pkgver-$pkgrel-x86_64.pkg.tar.zst";
# my $dbdir = "/usr/share/pacman"
# ssh localhost cp $dir/$pkgile $dbdir/";
# ssh localhost repo-add $dbdir/*.db.tar.zst $dbdir/$pkgfile --add-new";
    }

    my %info = _prepare(@_);
    my @want = grep { $info{$_}{vercmp} > 0 } keys %info;
    if ( !@want ) {
        return say "[OK] makepkg";
    }
    say "[-] makepkg";
    for (@want) {
        my $pkg   = $_;
        my $props = $info{$pkg};
        say "  * installing: $pkg $props->{version}";
    }
}

sub node {
    my @pkgs  = map { ${$_}[0] } @_;
    my $check = _check('source ~/.asdf/asdf.sh && asdf list nodejs');
    die "asdf nodejs plugin not found" if !$check->{ok};
    my @versions = $check->{out}       =~ /([^*\s]+)/mg;
    my $current  = $1 if $check->{out} =~ /\*(\S+)/;
    my @tasks    = ();
    for my $version (@versions) {
        my $check   = _check("ls ~/.asdf/installs/nodejs/$version/bin/");
        my %bins    = map  { $_ => 1 } split( " ", $check->{out} );
        my @missing = grep { !exists $bins{ $_->[0] } } @_;
        for my $ref (@missing) {
            push @tasks, sub {
                say "  * installing [$version]: $ref->[0]";
                my $cmd = "source ~/.asdf/asdf.sh";
                $cmd .= "&& asdf shell nodejs $version";
                $cmd .= "&& npm install -g $ref->[1]";
                _task($cmd);
            }
        }
    }
    if ( !@tasks ) {
        return say "[OK] node";
    }
    say "[-] node";
    $_->() for @tasks;
}

sub go {
    my @pkgs    = map { ${$_}[0] } @_;
    my $check   = _check( 'PATH=$PATH;~/.go/bin ' . "which @pkgs" );
    my %missing = map  { $_ => 1 } $check->{out} =~ /^which: no (\S+) in/mg;
    my @want    = grep { exists $missing{ $_->[0] } } @_;
    if ( !@want ) {
        return say "[OK] go";
    }
    say "[-] go";
    for my $ref (@want) {
        say "  * installing: $ref->[0]";
        _task("go install $ref->[1]");
    }
}

# }}} ------------------------------------------------------------------------
