use POSIX;
use strict;

my $file = $ARGV[0];

#Input file expected is OG*overall, with format:
#0     1     2     3     4     5     6          7         8
#Scaf\tPos1\tPos2\tScaf\tPos3\tPos4\tgene_name\trun_name\tOrthgroup_Name
#Where Pos1 and Pos2 are the positions of the segment the gene is in (which may contain more than one gene), Pos3 and Pos4 are the positions of this particular gene within that segment
#
#What this script does: goes through each segment within an orthogroup, and picks the longest gene, noting what run it was from, prints this out to a new file OG00000...N.txt, where N is a number from 0-N, so each nonoverlapping segment gets a separate gene entry. So non-overlapping orthologs are considered separately.


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
	#Create a name for each "location" - a group of genes that are orthologs and overlap
	$location = "$temp[0] $temp[1] $temp[2]";
	#If it's the first gene at this location...
	if ($first eq "T"){
		$first = "F";
		$prev = $location; 
		$to_print = $line;
		$hash{$location}{$temp[7]}[0] = $temp[5]-$temp[4]; #So have a hash for that location, which details the run_name, length, and the whole input line
		$hash{$location}{$temp[7]}[1] = $line;		

	}elsif ($location eq $prev){
		#So if you're still considering the same segment, if the new gene length for that run is longer than the old one, update the name
		if (($temp[5]-$temp[4]) > $hash{$location}{$temp[7]}[0]){
			$hash{$location}{$temp[7]}[0] = $temp[5]-$temp[4];
			$hash{$location}{$temp[7]}[1] = $line;		
		}
	}else{
		#As the file should be sorted, if $location ne $prev, we are onto the next gene segment.
		#For each gene segment, it will print a new file extension, $i (incremementing this), and will print out the relevant line from this file


		open(OUT, ">$file.$i.txt");
		foreach $item (keys %{$hash{$prev}}){
			print OUT $hash{$prev}{$item}[1]."\n";
		}
		close OUT;
		
		#Updates $prev as the new $location, to start the process again
		$prev = $location;		
		
		#Sets up the length/info for that entry, as before
		$hash{$location}{$temp[7]}[0] = $temp[5]-$temp[4];
		$hash{$location}{$temp[7]}[1] = $line;		
		print $hash{$location}{$temp[7]}[1]."\n";
		print "3\n";

		#Incremenets the number, so that you get the next one
		$i++;
	}
}
		#This is just making sure the very last segmeent gets printed
		open(OUT, ">$file.$i.txt");
		#So for each of the BRAKER runs, outputs the longest gene's bed entry into a new file, $file.$i.txt
		foreach $item (keys %{$hash{$prev}}){
			print OUT $hash{$location}{$item}[1]."\n";
		}


