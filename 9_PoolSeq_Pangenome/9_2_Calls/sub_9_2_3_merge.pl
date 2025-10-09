use POSIX;
use strict;

#This subfunction is called from PG2_15_4_mergecounts.sh

my $list = $ARGV[0]; #This is the list of names (31) - currently takes names="/data/home/mpx545/scripts/PG2_RealData/PG2_15_vgmap/PoolFileList.txt" as the argument
my $prefix = $ARGV[1]; #prefix for the file (specified as the directory name)
my $suffix = $ARGV[2]; #suffix for te file (specified as PG2_15_2.vcf.adstats
my $size = $ARGV[3]; #so this is num...the number of names (which should be 31)
#This subfunction is provided with an additional argument, but this shouldn't be read so I think it's ok

#So an empty array is created: 
my @empty = "0:0:0:0:0" x $size; #Note: I can see this is the wrong size.
#But it doesn't get used again subsequently so I'm not sure why it's here.
#Will delete in later versions
#
my ($line, $file, $line2, $name, $sync, %hash); #setting up variables
my (@temp, $c, $a); #setting up some more variables
open(IN, "<$list"); #Reading in the list of names...
my $i = 0; #A counter - one for each line of the file (aka Pool)
open(OUT, ">/data/home/mpx545/scripts/PG2_RealData/PG2_15_vgmap/temp_out"); #A temporary out file

#So the overall structure of this loop is to read in each Pool file
#Every variant should be specified as
#MajorAllele:MinorAllele:0:0:0:0
#So creates a $name for each variant (which should be the same in each file, as it's based on the input vcf)
#Using this as the key for a hash (so for non-hash users; a %hash is a data structure where each $key is linked uniquely to a $value
#, which you specify via $hash{$key} = $value - you can then recall the $value via $hash{$key}. Note that the keys are in random order
#Each $key and $value can themselves be arrays. In this script I used a has of arrays; so each $hash{$key} is an array: you can specifiy
#the $i'th value of the $name array by calling $hash{$name}[$i] 
while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	$line =~ s/\t.*//g;
	$file = "$prefix/$line.$suffix";
	print OUT $file."\n";
	open(IN2, "<$file");
	while(!eof(IN2)){
		$line2 = readline *IN2;
		chomp $line2;
		@temp = split/\t/, $line2; #splits the input line by tab
		$name = "$temp[0]\t$temp[1]\t$temp[2]A"; #Generating the name of the locus from the first two fields
		$sync = "$temp[5]:$temp[6]:0:0:0:0"; #Getting the sync part of the file
		#If $hash{$name} exists (i.e. this variant has been found in a previous pool file)
		if (exists($hash{$name})){
			$hash{$name}[$i] = $sync; #So for this pool file, every variant called should be in the $ith position of each array
		}else{
		#if it doesn't exist...
		#Create a new value in hhe hash, set everything else as 0, and stick it in there
		#So the order should then be the same across everything - which is just the order in *names
			$c++; #This just counted the total number of variabnts	
			$a =  0;
			#So this just sets up the new variant - going from 1->number of Pools, setting each to empty initially
			while($a < $size){
				$hash{$name}[$a] = "0:0:0:0:0:0";
				$a++;
			}
			#Then finally adding in the genotyopes for the newly discovered variant
			$hash{$name}[$i] = $sync;
		}
	}
	#so $i increases each line; i.e. each Pool has a unique value - and the order in the arrays should mirror the order in the input file
	$i++;
	#This just reports the total number of variants to some file
	print OUT "$c\n";
}
my ($part1, $part2, $item);
#So this is then specifying the output file
open(OUT2, ">$ARGV[0].joint");
#So for every $item in keys %hash (i.e. the name of each vairant)
foreach $item (keys %hash){
	#So  for the array specified by $hash{$item}, joins the values together separated by a tab. This should preserve the order
	$part2 = join("\t", @{ $hash{$item} });
	#prints this out as a string
	print OUT2 "$item\t$part2\n";
}
#So as far as I can tell, the order of each column should be the same as in the original input file, and should be the same across
#every variant (although if it wasn't, the PCA would just be a complete mess I would have thought)
