use POSIX;
use strict;

#This subfunction assumes...
#a) An input bed file, in co-ordinate system 1
#b) A conversion_bed file, which details how the co-ordinate system is translated into the next one...

my $input_bed=$ARGV[0];
my $conversion_bed=$ARGV[1];

#my $input_bed = "/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_20_pangenome_annotation/PG2_4_4_2/DW-S01_PG65/braker.gtf.bed";
#my $conversion_bed = "/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_20_pangenome_annotation/DW-S01_PG65.PG2_20_2.vcf.PG2_20_2.temp1.txt.PG2_20_2.kept.vcf_lines.bed.mod.fasta.conversion_bed";


#my $input_bed = "/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_20_pangenome_annotation/PG2_4_4_2/DW-S02_PG37/braker.gtf.bed";
#my $conversion_bed = "/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_20_pangenome_annotation/DW-S02_PG37.PG2_20_2.vcf.PG2_20_2.temp1.txt.PG2_20_2.kept.vcf_lines.bed.mod.fasta.conversion_bed";

open(OUT, ">$input_bed.refcoords");

#...so it seems like this works. Great!
#So then you can work out...which genes overlap with the genes in the reference genome, I guess?
#But might need to convert these back, excluding the "INV" co-ordinates or whatever. But this shouldn't be too bad.
#
#
my (%with_genes, @temp, $line);
open(IN, "<$input_bed");
while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	@temp = split/\t/, $line;
	$with_genes{$temp[0]} = "";
}

#So you can either try and do something that stores everything in memory, reads through everything a billion times, or somehow operates on the start sites alone (that would still require reading all the conversion co-ordinates into memory).

#So maybe constructing a binary search for this would be the way to go, then.

#So the idea would be to...
my $i = 0;
#Can at least do one chromosome at a time to save some memory, I guess

#So then we need to do the subfunction that reads in the features and does a binary search...
sub sub_function{

	my ($array_ref, $chrom, $input_file) = @_;
	my @array = @{$array_ref};
	my ($line, @temp, $low, $high, $j);
	open(IN2, "<$input_file");
	while(!eof(IN2)){
		$line = readline *IN2;
		chomp $line;
		@temp = split/\t/, $line;
#		print $line."\n";
		if ($temp[0] eq $chrom){
#			print $temp[0]."\n";	
			my $j = 1;
			my @new_coords = ();
			my @new_numbers = ();
			my @new_type = ();
			while($j < 3){
				my $feature_start = $temp[$j];
#				print $feature_start."\n";
				my $low = 0;
				my $high = $#array;
#				print scalar(@array)."\n";
				my $start_index = "";
				#Does a binary search to identify which segment corresponds to that feature...
#				print "feature start $feature_start\n";	
				while ($low+1 < $high){
					#So if L is your low point, H is your high point, M is the midpoint and T is your target...
		
					#L.......................H
					#           M
						 
					my $mid = int(($low+$high)/2); #Takes the midpoint index of the lowest and highest value...
#					print "\t1) $low ($array[$low][1]) \t$high ($array[$high][1]\t$mid ($array[$mid][1])\n";	
					#1) An exact match
		
					#           T
					#L.......................H
					#           M
	
		
					if ($feature_start == $array[$mid][1]){
#						print "doink\n";
						$high = $mid; #This should hopefully end the loop
						$low = $mid;
	
					#2) Target is less than the midpoint

					#     T      
					#L.......................H
					#           M


					}elsif($feature_start < $array[$mid][1]){
						$high = $mid;


					#3) Target is greater than the midpoint
	

					#                 T
					#L.......................H
					#           M


					}elsif($feature_start > $array[$mid][1]){
						$low = $mid;			
					}
#					print "\t2) $low ($array[$low][1]) \t$high ($array[$high][1])\t$mid ($array[$mid][1])\n";	

				}
						

				#Determining which is the correct value...
				my $high_diff = $array[$high][1] - $feature_start;
				my $low_diff = $array[$low][1] - $feature_start;
				if ($high_diff*$low_diff > 0){
					if (abs($high_diff) > abs($low_diff)){
						$start_index = $low;	
					}else{
						$start_index = $high;
					}
				}else{
					if ($high_diff == 0){
						$start_index = $high;
					}elsif($low_diff == 0){
						$start_index = $low;
					}elsif($low_diff < 0){
						$start_index = $low;
					}
				}				

#				if ($feature_start > $array[$high][1]){
#					$start_index = $high
#				}elsif($feature_start > $array[$low][1]){
#					$start_index = $low
#				}else{
#					print "feature start: $feature_start, array[high][1]: $array[$high][1] ($high), array[low][1]: $array[$low][1] ($low) - chosen $start_index\n";
#
#				die "ssome weird error";
#				}
	
#				print "$j feature start $feature_start, nearest value is $array[$start_index][1]...downstream and upstream are $array[$start_index-1][1] and $array[$start_index+1][1]\n";
	#			print "array[high][1] $array[$high][1]\n";
#				print "array[low][1] $array[$low][1]\n";
				$j++;
			
				push @new_coords, $start_index;
				push @new_numbers, $feature_start;
				push @new_type, $array[$start_index][5];
			}
			#So then, having both values of j...
#			print "start index $new_coords[0] $new_numbers[0] end index $new_coords[1] $new_numbers[1]\n";
			#So if they both correspond to the same segment, then it's kinda easy right:
			#The position in the new set of co-ordinates is just the old set, subtracted.
#			my $start_diff = 
			#So then...
			my $start_diff = $new_numbers[0] - $array[$new_coords[0]][1];
			my $end_diff = $new_numbers[1] - $array[$new_coords[1]][1];
	
#			print "start_diff $start_diff end_dif $end_diff\n";	
			my ($new_start, $new_end);

			if ($new_type[0] eq "segment"){
#				print "new segment start: $array[$new_coords[1]][3]\n";
				$new_start = $array[$new_coords[0]][3]+$start_diff;
#				print "so the new start is $new_start\n";
			}else{
				#So then if the start is in...an insertion...I guess...
				#Well then what do you do? Give the co-ordinate as the nearest old coordinate, plus the co-ordinate inside the
				 $new_start = "$array[$new_coords[0]][3]+$new_type[0].$start_diff";
#				print "so the new start is $new_start\n";
			}	


			if ($new_type[1] eq "segment"){
#				print "new segment end: $array[$new_coords[0]][3]\n";
				$new_end = $array[$new_coords[1]][3]+$end_diff;
#				print "so the new end is $new_end\n";


			}else{
				$new_end = "$array[$new_coords[1]][3]+$new_type[1].$end_diff";
#				print "so the new start is $new_end\n";
			
			}
#			print "$chrom Start: old position $new_numbers[0], in $new_type[0] ($new_coords[0]), new position $new_start. End: old position $new_numbers[1], in $new_type[1] ($new_coords[1]), new position $new_end\n";
			print OUT "$temp[0]\t$temp[1]\t$temp[2]\t$temp[3]\t$new_start\t$new_end\n";
		}		
	}
}

my ($line, @temp, $prev_chrom, @array);
my $first = "T";
my $i = 0;
#open(IN, "<$input_bed");
open(IN, "<$conversion_bed");
while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	@temp = split/ /, $line;
	if ($first eq "T"){
		$prev_chrom = $temp[0];
		$first = "F";
	}
	
	if ($temp[0] eq $prev_chrom){
		$array[$i][0] = $temp[0];
		$array[$i][1] = $temp[1];	
		$array[$i][2] = $temp[2];	
		$array[$i][3] = $temp[3];	
		$array[$i][4] = $temp[4];	
		$array[$i][5] = $temp[5];	
		$array[$i][6] = "$temp[0].$temp[3].$temp[4].$temp[5]";	
		$i++;
		#So this builds an array, with the start/end postions of each segment.
		#Can then do a binary search based on these...(with the start bit, anyway...)

	}else{
		#If it's a new chromosome - do the actual conversion step with the previous chromosome...
		#Start reading in the next bit for the next chromosome...
		print $prev_chrom."\n";
		my $test_num = scalar(@array);
#		print "prev_chrom $prev_chrom temp[0] $temp[0]\n";
#		print "test_num 1 $test_num\n";
	
		if (exists($with_genes{$prev_chrom})){
			print "$prev_chrom has genes\n";
			sub_function(\@array, $prev_chrom, $input_bed);
		}
#		print "$prev_chrom finished\n";
		@array = ();
		my $test_num = scalar(@array);
#		print "test_num 2 $test_num\n";

		$i = 0;
		$prev_chrom = $temp[0];

		$array[$i][0] = $temp[0];
		$array[$i][1] = $temp[1];	
		$array[$i][2] = $temp[2];	
		$array[$i][3] = $temp[3];	
		$array[$i][4] = $temp[4];	
		$array[$i][5] = $temp[5];	
		$array[$i][6] = "$temp[0].$temp[3].$temp[4].$temp[5]";	
		$i++;
		my $test_num = scalar(@array);
#		print "test_num 3 $test_num\n";


	}
}

if (exists($with_genes{$prev_chrom})){
	sub_function(\@array, $prev_chrom, $input_bed);
}

