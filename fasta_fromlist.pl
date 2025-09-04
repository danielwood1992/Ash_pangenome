use POSIX;
use strict;

my (%hash, $line, $seq, $name, $item);

my $list = $ARGV[0];
open(IN, "<$list");
while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	$hash{$line} = "";
}

my $fasta = $ARGV[1];
my $suffix = $ARGV[2];

open(OUT, ">$fasta.$suffix.fa");
open(IN, "<$fasta");
while(!eof(IN)){
	$name = readline *IN;
	chomp $name;
	$seq = readline *IN;
	chomp $seq;
	if ($name =~ m/^>/){
	}else{
		die "wrong fasta format\n";
	}
	$name =~ s/>//g;
#	print $name."\n";
	if (exists($hash{$name})){
		print OUT ">$name\n$seq\n";
	}
}
