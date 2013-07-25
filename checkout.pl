#!/usr/bin/perl -n

use strict;
use vars qw($file %contacts %per_user);
use feature qw(say);

if ($file ne $ARGV) {
    chop;
    $contacts{$ARGV} = $_;
    $file = $ARGV;
    next
}

if (/^(\d+)x? (.*)$/) {
    my $qty = $1;
    my $product = $2;

    $per_user{$file}{$product} = $qty
}

END {
    my %checkout, my $num = 1;

    while (my ($user, $products) = each %per_user) {
        say "Objednávka #$num ($contacts{$user})";
        say "----------------";
        while (my ($product, $qty) = each $products) {
            print $qty, "x $product\n";
            $checkout{$product} += $qty
        }

        say;
        $num++
    }

    say "Celkem";
    say "-------";
    while (my ($product, $qty) = each %checkout) {
        print $qty, "x $product\n"
    }
}
