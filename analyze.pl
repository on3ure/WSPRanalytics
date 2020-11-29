#!/usr/bin/perl

use Data::Dumper;
use Math::Round qw(nhimult);
use strict;

my $analytics;
while ( my $data = <STDIN> ) {
    chomp($data);

#print $data . "\n";
#spotID,timestamp,reporter,reporterGrid,snr,frequency,call,grid,power,drift,distance,azimuth,Band,version,code
    my ( $timestamp, $reporter, $snr, $call, $grid, $Band )
        = ( split( /\,/, $data ) )[ 1, 2, 4, 6, 7, 12 ];
    $Band = "10m" if $Band eq 28;
    $Band = "20m" if $Band eq 14;
    $Band = "40m" if $Band eq 7;
    $Band = "80m" if $Band eq 3;
    next if $reporter !~ /^ON3URE\/0/;
    $reporter = "LoopNS (1.2 meter)"      if ( $reporter eq "ON3URE/01" );
    $reporter = "Compactenna" if ( $reporter eq "ON3URE/02" );
    $reporter = "LoopEW (5 meter)"      if ( $reporter eq "ON3URE/03" );

    # Reporters
    $analytics->{Band}->{$Band}->{reporter}->{$reporter} = 1;

    # Total calls
    $analytics->{Band}->{$Band}->{calls}->{$reporter}++;

    # Uniq calls
    $analytics->{Band}->{$Band}->{Unique_Contacts}->{$reporter}->{$call} = 1;

    # Average SNR
    $analytics->{Band}->{$Band}->{Average_SNR}->{$reporter} += $snr;

}

#print Dumper $analytics;

my $stats;

foreach my $Band ( keys %{ $analytics->{Band} } ) {
print $Band . "\n";
    foreach my $reporter ( keys %{ $analytics->{Band}->{$Band}->{reporter} } ) {
print $reporter . "\n";
        $stats->{$Band}->{Unique_Contacts}->{$reporter}
            = scalar
             keys %{ $analytics->{Band}->{$Band}->{Unique_Contacts}->{$reporter} } ;
        $stats->{$Band}->{Total_Contacts}->{$reporter}
            = $analytics->{Band}->{$Band}->{calls}->{$reporter};
        $stats->{$Band}->{Average_SNR}->{$reporter}
            = nhimult(.1, $analytics->{Band}->{$Band}->{Average_SNR}->{$reporter}
            / $analytics->{Band}->{$Band}->{calls}->{$reporter});
    }
}

print Dumper $stats;
