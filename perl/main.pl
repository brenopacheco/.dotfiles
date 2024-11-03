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
