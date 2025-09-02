use POSIX;
use strict;

#Ensures each SV has a unique name

my $vcf = $ARGV[0];
open(IN, "<$vcf");
open(OUT, ">$vcf.uniqnames");
my ($line, @temp, $new_line);
while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	if ($line =~ m/^#/){
		print OUT $line."\n";
	}else{
		@temp = split/\t/, $line;
		$temp[2] = "$temp[2].$temp[0].$temp[1]";
		$new_line = join("\t", @temp);
		print OUT $new_line."\n";
	}
}
