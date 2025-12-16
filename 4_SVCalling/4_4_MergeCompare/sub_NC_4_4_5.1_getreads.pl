use POSIX;
use strict;

my $input = $ARGV[0];

my ($line, $scaff, $start, $end, @temp);

open(IN, "<$input");
open(OUT, ">$input.out");
while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	@temp = split/\t/, $line;
	$scaff = $temp[0];
	$start=$temp[1];
	#So to get the end...
	$end = $line;
	$end =~ s/.*;END=//g;
	$end =~ s/;.*//g;
	$start=$start-1000;
	$end=$end+1000;
	print OUT "$scaff\t$start\t$end\n";

}
