use POSIX;
use strict;

my ($line, @temp, %hash);

my $file = $ARGV[0];

open(IN, "<$file");
while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	@temp = split/\t/, $line;
	#	print $temp[-1]."\n";
	$hash{$temp[-1]} = "";
}

my ($file2, @temp2);

$file2 = $ARGV[1];
open(OUT, ">$file2.trimmed");

open(IN, "<$file2");
while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	if ($line =~ m/^file/){
		print OUT $line."\n";
	}else{
		@temp = split/\t/, $line;
		@temp2 = split/\//, $temp[0];
		$temp2[-1] =~ s/ .*//g;
		#		print "$temp2[-1]\n";
		if (exists $hash{$temp2[-1]}){
			print OUT $line."\n";
			print "woof\n";
		}

	}

}
