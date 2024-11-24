# Notes

## Alt 1

```perl
#!/usr/bin/env perl

use diagnostics;
use v5.38;

print "\n\n";

# Pacman =====================================================================
my @packages = ('git', 'zk');
say "Installing core packages";
system "ssh localhost pacman -S @packages" if
	system "ssh localhost pacman -Q @packages >/dev/null";


# my @makepkgs = ('dmenu-fork', 'dwm-fork', 'st-fork');
my @makepkgs = ('dmenu-fork');

say "Installing custom packages";
foreach my $pkg (@makepkgs) {
	# setup
	my $PKGBUILD = "files/pacman/$pkg/PKGBUILD";
	my $pkgver = $1 if `grep -m1 "pkgver=" $PKGBUILD` =~ /pkgver=(\S+)/;
	my $pkgrel = $1 if `grep -m1 "pkgrel=" $PKGBUILD` =~ /pkgrel=(\S+)/;
	my $ver = ($pkgver // die) . "-" . ($pkgrel // die);
	say "> Installing: $pkg $ver";
	# check
	my $iver = $1 if `ssh localhost pacman -Q $pkg` =~ /\s(.*)/;
	next if $ver eq ($iver // "");
	# build
	my $dir = `ssh localhost mktemp` or die;
	die if system "scp files/pacman/$pkg localhost:$dir";
	die if system "ssh localhost makepkg -scCf $dir";
	# install
	my $pkgfile = "$pkg-$pkgver-$pkgrel-x86_64.pkg.tar.zst";
	my $dbdir = "/usr/share/pacman"
	die if system "ssh localhost cp $dir/$pkgile $dbdir/";
	die if system "ssh localhost repo-add $dbdir/*.db.tar.zst $dbdir/$pkgfile --add-new";
}
```

## Alt 2

```perl
#!/usr/bin/env perl

use diagnostics;
use feature 'say';
use lib '.';
use Lib;

### Setup ====================================================================
my @makepkgs = ('dmenu-fork', 'dwm-fork');

my @packages = ( 'arandr', 'base', 'base-devel', 'bash-completion', 'bat',
    'bear', 'blueman', 'bluez', 'bluez-utils', 'bottom', 'chromium', 'cmake',
    'conky', 'ctags', 'dosfstools', 'dunst', 'dzen2', 'fd', 'feh',
    'file-roller', 'fzf', 'git', 'gparted', 'gpick', 'gtk2', 'gtk3', 'gtk4',
    'gvim', 'htop', 'imagemagick', 'inotify-tools', 'jq',
    'libappindicator-gtk3', 'lightdm', 'lightdm-gtk-greeter',
    'linux-zen-headers', 'lldb', 'lsof', 'man-db', 'moreutils', 'ncdu',
    'net-tools', 'network-manager-applet', 'ninja', 'pamixer', 'parted',
    'pass', 'pass-otp', 'pasystray', 'pavucontrol', 'pdftk', 'perl', 'polkit',
    'polkit-gnome', 'redshift', 'renameutils', 'ripgrep', 'rsync',
    'screengrab', 'sqlitebrowser', 'stow', 'sxiv', 'tmux', 'tree', 'udiskie',
    'unrar', 'unzip', 'usbutils', 'v4l2loopback-dkms', 'wget', 'wmctrl',
    'xarchiver', 'xclip', 'xdotool', 'xorg-server-xephyr', 'xorg-xev',
    'xorg-xkill', 'xorg-xlsclients', 'xorg-xmodmap', 'xorg-xsetroot',
    'xorg-xwininfo', 'zathura', 'zathura-pdf-mupdf', 'zip', 'zk');

my @commands = ();

### Root =====================================================================
@commands = ();

for my $pkgname (@makepkgs) {
    my ($src, $dst) = ("files/makepkg/$pkgver", "/tmp/$pkgver")
    my $pkgver = `grep -m1 'pkgver' $src` or die; $pkgver =~ s/pkgver=//; chomp($pkgver);
    my $buildcmd = "
        makepkg -scCf -d /tmp/makepkg/$pkgver &&
        cp /tmp/makepkg/$pkgver/*.pkg.tar.zst /usr/share/pacman/ &&
        repo-add --new /usr/share/pacman/*.db.tar.zst /usr/share/pacman/*.pkg.tar.zst
    ";
    push @commands, {
        name => "Build custom package $pkgname",
        shell => [
            sub { Lib::scp($src, $dst)}
            sub { Lib::ssh($buildcmd) }
        }
    }
};

Lib::exec 'root@localhost', @commands;

### User =====================================================================
@commands = ();

push @commands, {
    name => "Pacman install packages",
    shell => sub {  Lib::ssh("pacman -Q @packages || pacman -S --noconfirm @packages") },
};

push @commands, {
    name => "Pacman install custom packages",
    shell => sub {  Lib::ssh("pacman -Q @makepkgs || pacman -S --noconfirm @makepkgs") }
};

push @commands, {
    name => "Pacman update packages",
    shell => sub {  Lib::ssh("pacman --noconfirm -Syu") }
};

Lib::exec 'breno@localhost', @commands;
```

## Missing language configs

### DOTNET

```
pacman(
	"dotnet-sdk",
	"dotnet-sdk-6.0",
	"dotnet-sdk-7.0",
	"dotnet-runtime",
	"dotnet-runtime-6.0",
	"dotnet-runtime-7.0",
	"mono",
	"nuget",
	"aspnet-runtime",
	"aspnet-runtime-6.0",
	"aspnet-runtime-7.0"
);
```

Install netcoredbg

### ELIXIR+ERLANG

```
asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git
KERL_BUILD_DOCS="yes" asdf install erlang latest
asdf global erlang latest

asdf plugin add elixir https://github.com/asdf-vm/asdf-elixir.git
KERL_BUILD_DOCS="yes" asdf install elixir latest
asdf global elixir latest
```

### JAVA

```
pacman maven

asdf plugin add erlang https://github.com/halcyon/asdf-java.git

asdf install java openjdk-11:latest
asdf install java openjdk-13:latest
asdf install java openjdk-17:latest

export JAVA_HOME="$(asdf which java | sed 's/bin.java$//')"
```

### RUST

```
sudo pacman -S --noconfirm rustup &&
  rustup default nightly &&
  return "$OK"
```
