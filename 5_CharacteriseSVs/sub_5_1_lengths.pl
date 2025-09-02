use POSIX;

use strict;

#Gets the total lengths of variants in a file...
my $file = $ARGV[0];
my $maf = $ARGV[1];
my $length = $ARGV[2]; #not really surw why this is necessary


#Bascially reads through, gets lengths, makes a hash of types and adds the length to the types
my ($line, @temp, $sv_len, $sv_type, %hash);
open(IN, "<$file");
while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	if ($line =~ m/^#/){
	}else{
		@temp = split/\t/, $line;
		$sv_len=$temp[7]; # @temp[7# is the info filed7
		$sv_type=$temp[7];
		
		$sv_len =~ s/^.*SVLEN=//g;
		$sv_len =~ s/;.*//g;
		$sv_len =~ s/-//g;
	#	print $sv_len."\n";

		$sv_type =~ s/^.*SVTYPE=//g;
		$sv_type =~ s/;.*//g;
		$sv_type =~ s/-//g;
	#	print $sv_type."\n";
		if ($sv_len < $length){	
			$hash{$sv_type} = $hash{$sv_type}+$sv_len;
			$hash{"Total"} = $hash{"Total"}+$sv_len;
#			print OUT2 $sv_len."\n";
		}
	}
}
my ($item);
foreach $item (keys %hash){
	print "$maf $item $hash{$item}\n";
}
