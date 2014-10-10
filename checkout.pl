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

    my %prices = (
        "badge" => [0.69, 0.65, 0.59],
        "shaped" => [2.69, 1.99, 1.79],
        "keyboard" => [2.69,]
    );

    while (my ($user, $products) = each %per_user) {
        while (my ($product, $qty) = each $products) {
            $checkout{$product} += $qty
        }
    }

    my $total_price;

    while (my ($user, $products) = each %per_user) {
        my $user_price = 0;

        say "Objednávka #$num ($contacts{$user})";
        say "----------------";
        while (my ($product, $user_qty) = each $products) {
            my $item_price = 0;
            my $qty = $checkout{$product};

            foreach my $ident (keys %prices) {
                if ($product =~ /$ident/) {
                    my @price_list = @{$prices{$ident}};

                    my $level = $qty > 10 ? 2 : int($qty / 5);
                    $level = 0 if $level > scalar(@price_list);

                    $item_price = $price_list[$level];
                    $user_price += $user_qty * $item_price;

                    last
                }
            }

            print $user_qty, "x za $item_price $product\n";
        }

        my $czech = $user_price / 0.0462184;

        say "----------------";
        say "Celkem za \$$user_price, cca $czech Kč";

        say;
        $total_price += $user_price;
        $num++
    }


    say "Celková objednávka";
    say "------------------";
    while (my ($product, $qty) = each %checkout) {
        print $qty, "x $product\n";
    }

    say "------------------";
    say "Celkem: \$$total_price";
}
