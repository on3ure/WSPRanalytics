#!/usr/bin/perl

use Date::Parse;
use strict;

my $start = str2time("11/28/2020 00:00AM");
my $stop  = str2time("11/30/2020 00:00AM");

while ( my $data = <STDIN> ) {
    chomp($data);
	#spotID,timestamp,reporter,reporterGrid,snr,frequency,call,grid,power,drift,distance,azimuth,Band,version,code
    my ( $timestamp, $reporter, $snr, $call, $grid, $Band )
        = ( split( /\,/, $data ) )[ 1, 2, 4, 6, 7, 12 ];
    next if ( $timestamp < $start );
    next if ( $timestamp > $stop );
    print $data . "\n"
}
