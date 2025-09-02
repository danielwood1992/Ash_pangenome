use POSIX;
use strict;
my $table_file = $ARGV[0];
open(IN, "<$table_file");
open(OUT, ">$table_file.noN");
my($line, @temp);
while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	@temp = split/\t/, $line;
	if ($temp[1] =~ m/N/){
	}else{
		print OUT $line."\n";
	}
}
