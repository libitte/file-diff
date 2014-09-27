#!/usr/bin/env perl
use strict;
use warnings;

use Digest::MD5;
use Getopt::Long::Descriptive;
use File::Basename;
use Carp ();
use Data::Dumper;
local $Data::Dumper::Terse = 1;
local $Data::Dumper::Indent = 0;
local $Data::Dumper::Pair = '=>';

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

    my $md5_1 = _get_md5sum($file1);
    my $md5_2 = _get_md5sum($file2);

    exit(1) unless $md5_1 && $md5_2;

    if ($md5_1 eq $md5_2) {
        print "Files match!!!\n";
    }
    else {
        print "Files do not match.\n";
    }
    exit;
}

sub _get_md5sum {
    my ($file) = @_;

    my $digest = '';
    eval {
        open my $fh, '<', $file
            or Carp::croak "Can't open file:$file. $!";
        my $ctx = Digest::MD5->new;
        $ctx->addfile(*$fh);
        $digest = $ctx->hexdigest;
        close $fh;
    };
    if (my $m = $@) {
        print "ERROR: $m\n";
        return;
    }
    return $digest;
}

