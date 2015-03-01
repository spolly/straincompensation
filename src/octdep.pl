#!/usr/bin/perl -w

# Octave dependency check
# Copyright (C) 2014 Alex J. Grede
# GPL v3, See LICENSE for details

use warnings;
use strict;
use File::Basename;

{
    sub getdeps;

    sub getdeps ($$$) {
        my ($d,$p,$i) = @_;
        my @deps = split(/\n/, `grep -E -o -e '([[:alpha:]]+[[:alnum:]_]*)\\(' $p | sort -u | gawk 'sub(/[\\(]/,"") {print \$1 ".m"}' | xargs -n 1 find $d -name`);
        for my $dep (@deps) {
            next if ($dep eq "0");
            my ($file, $dir, $ext) = fileparse($dep, qr/\.[^.]*/);
            my $path = join('',$dir,$file,$ext);
            if (!defined($i->{$file})) {
                $i->{$file} = $path;
                getdeps($d,$path,$i);
            }
        }
        return 1;
    }
}

my ($file, $dir, $ext) = fileparse($ARGV[0], qr/\.[^.]*/);
my $path = join('',$dir,$file,$ext);
my $incl = {};
$incl->{$file} = $path;

getdeps($dir,$path,$incl);

print '' . join("\n",sort(values(%{$incl}))) . "\n";
