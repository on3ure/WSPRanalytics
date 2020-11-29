#!/usr/bin/perl

use strict;

while ( my $data = <STDIN> ) {
    chomp($data);
	#spotID,timestamp,reporter,reporterGrid,snr,frequency,call,grid,power,drift,distance,azimuth,Band,version,code
    my ( $timestamp, $reporter, $snr, $call, $grid, $Band )
        = ( split( /\,/, $data ) )[ 1, 2, 4, 6, 7, 12 ];
    print $data . "\n" if $reporter =~ /^ON3URE/;
}
