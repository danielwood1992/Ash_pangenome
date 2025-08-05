use POSIX;
use strict;

my ($line, %hash, @temp, $my_length, $seq, $header);

my $fasta = $ARGV[0]; #First argument is input fasta
my $min_length = 30; #Specify inout aa length

#Opens in fasta - reads in header and sequence, throws error if fasta is interleaved...
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

	#Splits header line by "."
	@temp = split/\./, $header;
	$my_length = length($seq);
	#Provided sequence length is greater than $length,
	#Populates a %hash with key being the second element when splititng the header by "." (the gene name)
	#and the values being the header, the sequence length
	#Once this goes through the whole file you should get the longest sequence per gene
	if ($my_length > $min_length){
		if ($hash{$temp[1]}[2] < $my_length){
			$hash{$temp[1]}[0] = $header;
			$hash{$temp[1]}[1] = $seq;
			$hash{$temp[1]}[2] = $my_length;
		}
	}
}

open(OUT, ">$fasta.longest.fa");
my $item;
#Foreach of the keys in hash, prints out the corresponding fasta header and sequence to $fasta.longest.fa
foreach $item (keys %hash){
	print OUT "$hash{$item}[0]\n$hash{$item}[1]\n";
}
