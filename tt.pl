#!/usr/bin/perl

use Date::Parse;
use Data::Dumper;

my $start = str2time("10/17/2020 00:00AM");
my $stop = str2time("10/24/2020 00:00AM");

#print $start . " " . $stop . " " . time() . "\n";

my $gridmap;
my $count;
while(my $data = <STDIN>) {
	chomp($data);
	#print $data . "\n";
	#spotID,timestamp,reporter,reporterGrid,snr,frequency,call,grid,power,drift,distance,azimuth,band,version,code
	my ($timestamp, $reporter, $snr, $grid, $band) = (split( /\,/, $data))[1,2,4,7,12]; 
	next if ($timestamp < $start);
	next if ($timestamp > $stop);
	next if ($band ne '14');
	$gridmap->{$grid}++;
	$count++;
	print $timestamp . " " . $reporter . " " . $snr . " " . $band . "\n";
}

print $count . "\n";
print scalar keys %{$gridmap} . "\n";
print Dumper $gridmap;
