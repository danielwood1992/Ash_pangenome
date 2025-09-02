use POSIX;
use strict;

#Output of sub_PG2_12_4.1 -bed file with the start and end position of each SV, and the sequence...
#Go through and comment this better

my $bounds = $ARGV[0];
my $vcf = $ARGV[1];
my ($line, @temp, @temp2, %hash);

open(IN, "<$bounds");
while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	@temp = split/\t/, $line;
	@temp2 = split/:/, $line;
	$hash{$temp2[0]}{$temp[0]} = $temp[1]; #So $hash{scaff}{scaf:bounds} = sequence
	print "$temp2[0]\t$temp[0]\n";
}


open(IN, "<$vcf");
open(OUT, ">$vcf.reffixed2");
open(OUT2, ">$vcf.reffixed2.changes");
print OUT2 "Scaff Start End Old_Seq New_Seq\n";
my ($start, $end, $scaff, $expr, $new_line, $alt);
while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	if ($line =~ m/^#/){
		print OUT $line."\n"; #prints out the header lines
	}else{
		@temp = split/\t/, $line;
		$scaff = $temp[0];
		$start = $temp[1];
		$end = $temp[7]; #finds the end postion
		$end =~ s/.*;END=//g;
		$end =~ s/;.*//g;
		$start = $start-1; #finds the start position
	
		my $expr = "$scaff:$start-$end";
		if (exists $hash{$scaff}{$expr}){
			print "woof\n";
			print OUT2 "$scaff $start $end $temp[3] $hash{$scaff}{$expr}\n"; #This just makes a note in a new file
			#of what is being changd
			$temp[3] = $hash{$scaff}{$expr}; #This alters the reference base to be accurate
			if ($line =~ m/SVTYPE=DEL/){
				$alt = (split//, $temp[3])[0]; #if it's a deletion, this sets the reference and alt sequences
				#to be correct
				$temp[4] = $alt;
			}
			$new_line = join("\t", @temp); #puts the line back together and prints it
			#print $new_line."\n";
			print OUT $new_line."\n";
		}else{
		#If it doesn't exist in the .tab file, it's probably because it overlaps with the end of a scaffold
#			print OUT $line."\n";
		#DW note 02.09/25 - this seems a bit dangerous?	
		}	

	}
}
