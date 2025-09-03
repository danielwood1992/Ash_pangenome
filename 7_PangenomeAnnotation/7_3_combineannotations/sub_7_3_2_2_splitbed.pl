use POSIX;
use strict;

my $file = $ARGV[0];

#This file will look a bit like this:
#
#Field 0		 1		 2		 3			 4		 5		 6	 7       8
#Scf9YQZ_100_HRSCAF_120  21222803        21228364        Scf9YQZ_100_HRSCAF_120  21222803        21228364        g799.t1 SR      OG0012669
#Scf9YQZ_100_HRSCAF_120  21222803        21228364        Scf9YQZ_100_HRSCAF_120  21222803        21228364        g804.t2 LR      OG0012669

open(IN, "<$file");

my (%hash, $line, @temp, $first, $prev, $location, $to_print, $item, $temp_item);
my $i = 0;
my $first = "T";
my %hash;
#So if there are multiple genes assigned to one location, take the longest

while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	@temp = split/\t/, $line;
	# "location" is referring to the total overlapping segment here. 
	#  So this is just selecting the longeest gene of the genes that overlap
	$location = "$temp[0] $temp[1] $temp[2]";
	if ($first eq "T"){
		$first = "F";
		$prev = $location;
		$to_print = $line;
		#So this is getting $hash{$segment}{LR}[0] = length
		#And $hash{$segment}{LR}[1] = the whole line
		$hash{$location}{$temp[7]}[0] = $temp[5]-$temp[4]; #gets the length
		$hash{$location}{$temp[7]}[1] = $line;		

	}elsif ($location eq $prev){
		
		
	
		if (($temp[5]-$temp[4]) > $hash{$location}{$temp[7]}[0]){
			$hash{$location}{$temp[7]}[0] = $temp[5]-$temp[4];
			$hash{$location}{$temp[7]}[1] = $line;		
		}
	}else{

		#Prints out the longest of the non-overlapping genes, for both the LR and SR runs
		#If SR has more than 2 overlapping genes that are the same ortholog, print out the longest
		#I think this might just be a hangover from when the script was used for assessing multiple runs of SR/LR
		open(OUT, ">$file.$i.txt");
		foreach $item (keys %{$hash{$prev}}){
			print OUT $hash{$prev}{$item}[1]."\n";
		}
		close OUT;
		$prev = $location;		
#		my %hash = ();
		

		
		$hash{$location}{$temp[7]}[0] = $temp[5]-$temp[4];
		$hash{$location}{$temp[7]}[1] = $line;		
		print $hash{$location}{$temp[7]}[1]."\n";
		print "3\n";

	
		$i++;
	}
}
		open(OUT, ">$file.$i.txt");
		foreach $item (keys %{$hash{$prev}}){
			print OUT $hash{$location}{$item}[1]."\n";
		}


