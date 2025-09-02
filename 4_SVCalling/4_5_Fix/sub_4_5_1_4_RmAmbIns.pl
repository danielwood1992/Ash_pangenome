use POSIX;
use strict;

#This removes <INS> which are ambiguous insertions - not sure if this is that the sequence is ambiguous?

my $vcf = $ARGV[0];
open(IN, "<$vcf");
open(OUT, ">$vcf.1");

my ($line, @temp, $new_line, $to_print);
while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	if ($line =~ m/^#/){
		print OUT $line."\n";
	}else{
		@temp = split/\t/, $line;
		$to_print="Y";
		
		if ($temp[4] =~ m/<INS>/){
			$to_print = "N";
		}
		
		if ($to_print eq "Y"){
			print OUT $line."\n";
		}
	}
}
