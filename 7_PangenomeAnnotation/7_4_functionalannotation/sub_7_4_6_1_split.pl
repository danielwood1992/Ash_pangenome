use POSIX;
use strict;

#Reads in fasta, writes out a file fasta.$j.fasta, every 8k lines $j++, starts a new file

my $file = $ARGV[0];
open(IN, "<$file");
my $i = 0;
my $j = 0;

my ($name, $seq);

open(OUT, ">$file.$j.fasta");
while(!eof(IN)){
	$i++;
	$name = readline *IN;
	chomp $name;
	$seq = readline *IN;
	chomp $seq;
	if ($name =~ m/^>/){
	}else{
		die "wrong fasta format\n";
	}
	$seq =~ s/\*//g;
	print OUT "$name\n$seq\n";
	if ($i == 8000){
		$j++;
		close OUT;
		open(OUT, ">$file.$j.fasta");
		$i = 0;
	}	
 
}		

