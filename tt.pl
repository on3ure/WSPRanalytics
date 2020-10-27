#!/usr/bin/perl

use Date::Parse;
use Data::Dumper;
use Math::Round qw(nhimult);
use strict;

my $start = str2time("10/17/2020 00:00AM");
my $stop  = str2time("10/24/2020 00:00AM");

#print $start . " " . $stop . " " . time() . "\n";

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
    $reporter = "LoopNS (1.2 meter)"      if ( $reporter eq "ON3URE/01" );
    $reporter = "Compactenna" if ( $reporter eq "ON3URE/02" );
    $reporter = "LoopEW (5 meter)"      if ( $reporter eq "ON3URE/03" );
    next if ( $timestamp < $start );
    next if ( $timestamp > $stop );

    #next if ($Band ne '14');
    #$data->{$reporter}->{gridmap}->{$grid}++;
    #$data->{$reporter}->{sendermap}->{$call}++;
    $analytics->{reporters}->{$reporter} = 1;

    # Total calls
    $analytics->{Band}->{$Band}->{calls}->{$reporter}++;

    # Uniq calls
    $analytics->{Band}->{$Band}->{Unique_Contacts}->{$reporter}->{$call} = 1;

    # Average SNR
    $analytics->{Band}->{$Band}->{Average_SNR}->{$reporter} += $snr;

    #print $timestamp . " " . $reporter . " " . $snr . " " . $Band . "\n";
}

my $stats;

#print Dumper $analytics->{calls};
#print Dumper $analytics->{Unique_Contacts};
foreach my $Band ( keys %{ $analytics->{Band} } ) {
    foreach my $reporter ( keys %{ $analytics->{reporters} } ) {
        $stats->{$Band}->{Unique_Contacts}->{$reporter}
            = scalar
            keys %{ $analytics->{Band}->{$Band}->{Unique_Contacts}->{$reporter} };
        $stats->{$Band}->{Total_Contacts}->{$reporter}
            = $analytics->{Band}->{$Band}->{calls}->{$reporter};
        $stats->{$Band}->{Average_SNR}->{$reporter}
            = nhimult(.1, $analytics->{Band}->{$Band}->{Average_SNR}->{$reporter}
            / $analytics->{Band}->{$Band}->{calls}->{$reporter});
    }
}

print Dumper $stats;

#my $grids = scalar keys %{$gridmap};
#my $senders = scalar keys %{$sendermap};
#print $grids . "\n";
#print $senders . "\n";
##print Dumper $gridmap;
