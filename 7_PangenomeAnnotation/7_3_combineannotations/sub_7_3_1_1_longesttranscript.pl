use POSIX;
use strict;

my $fasta = $ARGV[0];
my ($line, %hash, @temp, $my_length, $seq, $header);
my $min_length = 30;
open(IN, "<$fasta");
while(!eof(IN)){
	$header = readline *IN;
	chomp $header;
	$seq = readline *IN;
	chomp $seq;
	if ($header =~ m/^>/){
	}else{
		die "one fasta sequence per line needed\n";
	}
	@temp = split/\./, $header;
	$my_length = length($seq);
	if ($my_length > $min_length){
		if ($hash{$temp[2]}[2] < $my_length){
			$hash{$temp[2]}[0] = $header;
			$hash{$temp[2]}[1] = $seq;
			$hash{$temp[2]}[2] = $my_length;
		}
	}
}

open(OUT, ">$fasta.longest.fa");
my $item;
foreach $item (keys %hash){
	print OUT "$hash{$item}[0]\n$hash{$item}[1]\n";
}
