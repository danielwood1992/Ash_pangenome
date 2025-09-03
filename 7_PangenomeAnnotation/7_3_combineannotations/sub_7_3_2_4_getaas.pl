use POSIX;
use strict;

#Try and make general-ish.
my $longest_bed = $ARGV[0];
my $aa_file = $ARGV[1];
my $pattern = $ARGV[2];

my ($line, @temp, %hash);
#Makes a hash

open(IN, "<$longest_bed");
while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	@temp = split/\t/, $line;
	#Only searches for genes in the LR aa file that match LR (specified by $temp[7]
	if ($temp[7] eq "$pattern"){
#		print $temp[6]."\n";	
		$hash{$temp[6]} = ""; #$temp[6] will be the name of the gene.trancsript
	}
}

my ($name, $seq);
open(IN, "<$aa_file");
open(OUT, ">$aa_file.4comb");
#Read in fasta file, if the gene name is in the list to retrieve, print this out to the .4recomb file
while(!eof(IN)){
	$name = readline *IN;
	chomp $name;
	$seq = readline *IN;
	chomp $seq;
	if ($name =~ m/^>/){
	}else{
		die "wrong file format of fasta file";
	}
	@temp = split/\./, $name;
	if (exists ($hash{"$temp[-2].$temp[-1]"})){
		print OUT "$name\n$seq\n";	
	}
}
