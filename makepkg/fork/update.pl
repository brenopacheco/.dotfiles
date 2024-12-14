#!/usr/bin/env perl
use diagnostics;

for my $dir (glob '*/') {
    system("makepkg -scCf --dir $dir --noarchive");
}



