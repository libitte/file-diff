#!/usr/bin/env perl
use strict;
use warnings;

use Text::Diff;
use Digest::MD5;
use Getopt::Long::Descriptive;
use File::Basename;
use Carp ();
use Tie::File;

my $ME = basename($0, '.pl');

my ($opts, $usage) = describe_options(
    "$ME.pl %o",
    ["file1|f1=s", "file1"],
    ["file2|f2=s", "file2"],
    ["help", "print this message"],
);

if ($opts->help) {
    print $usage->text;
    exit;
}

unless ($opts->{file1} && $opts->{file2}) {
    print '$opts->{file1} and $opts->{file2} are required.', "\n";
    print $usage->text;
    exit;
}

MAIN: {
    my $file1 = $opts->{file1};
    my $file2 = $opts->{file2};

    my @file1;
    tie @file1, 'Tie::File', $file1;
    @file1 = sort { $a cmp $b } @file1;
    my @file2;
    tie @file2, 'Tie::File', $file2;
    @file2 = sort { $a cmp $b } @file2;

    #my $diff = diff $file1, $file2, { STYLE => 'Context' };
    my $diff = diff \@file1, \@file2;
    unless ($diff) {
        print "Files match!!!\n";
        exit;
    }
    print "*** DIFF ***\n";
    print "$diff\n";
    #print "diff exists\n";
    exit;
}

