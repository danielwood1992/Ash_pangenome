use POSIX;
use strict;

#Takes in i) the lines from a vcf (which don't overlap, contain DUPs etc.) and ii) a fasta file. Uses the vcf features to modifiy the fasta file.
#Things it  doesn't do yet:
#Skips features that are immediately next to each other (e.g. one ends where the next begins) - this is about 5/120k features.
#Skips tandem dups
#For inversions that for some reason don't have the alt sequence reported, does the reverse complement of ref sequence and outputs this.
#For insertions that don't have the first alt base the same as the ref base, adds this.
#Skips inversions that also change size (vg also skips these)

#Assumes...
#.bed file from the previous script - no overlapping SVs. Sorted by chromosome then by position.
my $vcf_lines = $ARGV[0];
my $fasta = $ARGV[1];

#my $vcf_lines = "/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_20_pangenome_annotation/DW-S01_PG65.PG2_20_2.vcf.PG2_20_2.temp1.txt.PG2_20_2.kept.vcf_lines.bed";
#my $fasta = "/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta.oneline.fasta";

open(OUT, ">$vcf_lines.mod.fasta");
open(OUT2, ">$vcf_lines.mod.fasta.conversion_bed");

#So this conversion bed should have the bed file of the new reference, and then things referring to the bed file of the old reference or particular SVs that are present.
#So...yeah, tricky. But let's try it...

my %hash2; #for tracking which contigs have been modified

my ($chrom, $start, $end, $type, $ref, $alt, $line, %hash, $name, $seq, @info, $chrom_scaff, $prev_pos, $new_string, $first, $temp_length);
my ($length, $new_length, $old_length, $calculated_diff);

my ($seg_old_start, $seg_old_end, $seg_new_start, $seg_new_end, $sv_old_start, $sv_old_end, $sv_new_start, $sv_new_end, $sv_length, $start_mod);


# Make a hash of $hash{chromosome_name} = sequence
open(IN, "<$fasta");
while (!eof(IN)) {
	$name = readline *IN;
	$seq = readline *IN;
	chomp $name;
	chomp $seq;
	$name =~ s/>//g;
	$hash{$name} = $seq;
}

$first = "T";
my $skip = "F";

my ($chrom_scaff, $prev_chrom, $new_segment, $to_add);
my $diff = 0;
open(IN, "<$vcf_lines");
while (!eof(IN)) {
	$line = readline *IN;
	chomp $line;
	
	($chrom, $start, $end, $type, $length, $ref, $alt) = split/\t/, $line;

#	print "$chrom $prev_chrom\n";
	
	#Sets stuff up for the first one
	if ($first eq "T") {
		$first = "F";
		$prev_chrom = $chrom;
		$prev_pos = 1;
		$new_string = "";
		$hash2{$chrom} = "yep"; #flags chromosome as being modified
		$start_mod = 1;

	}

	#A new chromosome - wraps up the old chromosome and starts the new one going
	#If trying to understand the script, maybe skip to the next bit
	if ($chrom ne $prev_chrom) {

		$hash2{$chrom} = "yep"; #flags chromosome as being modified 
#		print "new_chrom\n";
		
		#Gets a new segment - from the last position to the end of the chromosome	
		$new_segment = substr($hash{$prev_chrom}, $prev_pos-1);
		#Adds this to "new_string" the chromosome
		$new_string = $new_string.$new_segment; 
	
		#Finish of seg stuff...	
		$seg_old_start = $prev_pos;
		$seg_old_end = length($hash{$prev_chrom});
		
		$seg_new_start = $start_mod;
		$seg_new_end = $start_mod+$seg_old_end-$prev_pos; 	
		my $temp1 = $seg_new_end - $seg_new_start;
		my $temp2 = $seg_old_end - $seg_old_start;
		
	
		print OUT2 "$prev_chrom $seg_new_start $seg_new_end $seg_old_start $seg_old_end segment $temp1 $temp2\n";		

		#Calculates final length of string, and old length
		$new_length = length($new_string);
		$old_length = length($hash{$prev_chrom});
		#Works out the differences in length between total string and individual lengths - check STDOUT to see if there are problems
		$calculated_diff = $old_length-$new_length;
#		print "$diff\t$calculated_diff\t";
		$diff =~ s/-//g;
		$calculated_diff =~ s/-//g;
		$calculated_diff = $calculated_diff-$diff;
#		print "$prev_chrom\tnew string length = $new_length, old length = $old_length, diff = $diff, discrepency = $calculated_diff\n";

		#Print the chromosome name and new sequence 
		print OUT ">$prev_chrom\n$new_string\n";

		#Resets the variables
		$new_length = "";
		$old_length = "";
 		$prev_chrom = $chrom;
		$prev_pos = 1;
		$new_string = "";
		$diff = 0;
	
		#Resets the length counters...
		$start_mod = 1;


	}
	
	#So if the chromosome on this line matches that on the previous line (or the previous chrom has been dealt with)...
	if ($chrom eq $prev_chrom) {
		#Gets the implied next segment - the sequence after the last position, to the start of the SV
		$new_segment = substr($hash{$chrom}, $prev_pos-1, $start-$prev_pos+1);
		
		#To OUT2, print out i) chrom, ii) position in new sequence, iii) position in old sequence
		#print OUT2 $chrom $
		#print OUT2 $chrom $pos_new
		#Sanity check 1: the reference position in the fasta and the first position of the reference in the vcf should match
		#So it should then be up to the new segment

		my $fasta_ref = substr($new_segment, -1, 1);

		my $vcf_ref = substr($ref, 0, 1);

		if ($fasta_ref eq $vcf_ref){
#			print "Sanity 1 passed...";
		}else{
			#This sanity check can fail if the SVs are immediately adjacent - skip these for now, represent a tiny minority of sites and are probably weird errors
#			print "possible error or overlapping SVs, skip - $line\n$prev_pos-1 $start-$prev_pos+1\n$fasta_ref $vcf_ref bad\n";
			$skip = "T";
		}


	
		#Previous segment
		$seg_old_start = $prev_pos;
		$seg_old_end = $start-1;
	
		print "Segment\n";
	
		print "prev_pos: $prev_pos\n seg_old_start: $seg_old_start\n start: $start\n seg_old_end: $seg_old_end\n";

		$seg_new_start = $start_mod;
		$seg_new_end = $start_mod+$start-$prev_pos-1; #i.e. start_mod + length	

		my $temp1 = $seg_new_end - $seg_new_start;
		my $temp2 = $seg_old_end - $seg_old_start;

		print "start_mod: $start_mod\n seg_new_start: $seg_new_start\n seg_new_end: $seg_new_end = start_mod+start-prev_pos\n";
		print OUT2 "$chrom $seg_new_start $seg_new_end $seg_old_start $seg_old_end segment $temp1 $temp2\n";		

		#Skip the ones with a skip flag	
		if ($skip eq "T"){	
			$skip = "F";
		}else{

			if ($type eq "DEL"){
				$sv_length = 0;
#				print "type = DEL\t";
				$length = length($ref)-1;
				$diff = $diff - $length;			
				#If it's a deletion...
				#Add the sequence between the SVs to the string
				$new_string = $new_string.$new_segment;
				#So skips over the sequence covered by the deletion
				$prev_pos = $end+1; #So this just skips over everything betwen the start and the end.
	
				#DEL sanity check: $prev_position -1 should be the last position in the ref allele...			
				my $vcf_ref = substr($ref, -1, 1);
				my $fasta_ref = substr($hash{$chrom}, $prev_pos-2,1);
				if ($fasta_ref eq $vcf_ref){
#					print "Sanity 2 (DEL) passed - $fasta_ref = $vcf_ref\n";
				}else{
#					print $line."\n";
					die "bad deletion\tfasta ref: $fasta_ref\tvcf_ref\t$vcf_ref\n";
					#...so why is the ref T here? 
				}
				 	
		
			}elsif($type eq "INS"){
#				print "type = 0INS\t";
				
				#Sanity check 2: first base of insertion alt should be the same as the reference position... 
				my $vcf_ref = substr($alt, 0, 1);
				my $fasta_ref = substr($hash{$chrom}, $start-1,1);
				if ($fasta_ref eq $vcf_ref){
#					print "Sanity 2 (INS) passed - $fasta_ref = $vcf_ref\n";
				}else{
					#A few insertions seem not to have the first base the same as the ref for some reason - so adding this
#					print $line."\n";
#					print "bad insertion\tfasta ref: $fasta_ref\tvcf_ref\t$vcf_ref, adding ref to beginning\n";
					$alt= $ref.$alt;
					#...so why is the ref T here? 
				}

				$length = length($alt)-1;
				$diff = $diff + $length;			
				$sv_length = $length;
				#Adds the new segment (between the two SVs) to the string
				$new_string = $new_string.$new_segment;			
				$to_add = substr($alt, 1); #defaults to end of substring; so should skip the first item (which should still be the ref);
#				$to_add = lc($to_add);

				#Adds the insertion sequence to the string
				$new_string = $new_string.$to_add;
				#New prev_pos is the next base after the start of the insertion
				$prev_pos = $start+1;
		
			
			#	print $to_add."\n";		
			}elsif($type eq "INV"){
			
				#So inversions seem a bit more complicated...
#				print $alt."\n";
				#So if the alt is just <INV> rather than the inversion sequence, manually reverse complement the supplied reference seq
				if ($alt eq "<INV>"){
#					print "INV conversion 1/2: $alt\n";
					$alt = reverse $ref; #reverse
					$alt =~ tr/ACGTacgt/TGCAtgca/; #complement
#					print "INV conversion 2/2: $alt\n";

				}	
				
				#Once this is done - if the ref and alt aren't the same length, skip the variant (don't think this is many - but these are also skipped in vg)		
				if (length($ref) ne length($alt)){
				}else{
					#Remove the first base of the between variant sequence which by default includes the reference... 
					$new_segment = substr($new_segment, 1);
#					print "temp length INV1 $temp_length\n";
					$new_string = $new_string.$new_segment;
					my $temp_length = length($new_string);
#					print "temp length INV2 $temp_length\n";
					$new_string = $new_string.$alt;
					my $temp_length = length($new_string);
#					print "temp length INV3 $temp_length\n";
	
					$prev_pos = $end+1; #So this just skips over everything betwen the start and the end.
					$sv_length = $end-$start;

				}
				
			}else{
				die "unrecognised SV type: $type\n";
			}		

		my $temp_length = length($new_string);
#		print "temp length $temp_length\n";
	
		#Printing out to old to new bed file...

		#SV
		$sv_old_start = $start;
		$sv_old_end = $end;

		print "SV\n";
		
		print "start: $start\n end: $end\n sv_old_start: $sv_old_start\n sv_old_end: $sv_old_end\n";

		$sv_new_start = $seg_new_end+1;
		$sv_new_end = $sv_new_start+$sv_length; 

		print "sv_new_start = seg_new_end+1 = $sv_new_start\n sv_new_end: $sv_new_end\n sv_length: $sv_length\n";

		my $temp1 = $sv_new_end - $sv_new_start;
		my $temp2 = $sv_old_end - $sv_old_start;



		print OUT2 "$chrom $sv_new_start $sv_new_end $sv_old_start $sv_old_end $type $temp1 $temp2\n";		

		

		#Reset for next one...	
		$start_mod = $sv_new_end+1;
	
	#Per site check
	#	print $new_segment."\n";
	#	my $Lcheck_segment = substr($hash{$prev_chrom}, $prev_pos-1);
	#	my $Lcheck_string = $new_string.$Lcheck_segment;
	#	my $Lcheck_new_length = length($Lcheck_string);
	#	my $Lcheck_old_length = length($hash{$prev_chrom});
	#	my $Lcheck_calculated_diff = $Lcheck_old_length-$Lcheck_new_length;
	#	my $Lcheck_diff = $diff;
	#	$Lcheck_calculated_diff =~ s/-//g;
	#	$Lcheck_diff =~ s/-//g;
	#	$Lcheck_calculated_diff = $Lcheck_calculated_diff - $Lcheck_diff;
	#	#WHERE I LEFT OFF: So calculatd diff is bigger...for a few of these...
	#	print "temp discrepency = $Lcheck_calculated_diff\n";


		}
	}
}	

#Complete the final chromosome...
#my ($new_string, $new_length, $old_length) = finish_chromosome($prev_chrom, \%hash, $prev_pos, $new_string , \%hash2, $diff);

$new_segment = substr($hash{$prev_chrom}, $prev_pos-1);
$new_string = $new_string.$new_segment;
$new_length = length($new_string);
$old_length = length($hash{$prev_chrom});
$calculated_diff = $old_length-$new_length;
#print "$diff\t$calculated_diff\t";
$diff =~ s/-//g;
$calculated_diff =~ s/-//g;
$calculated_diff = $calculated_diff-$diff;
#print "$prev_chrom\tnew string length = $new_length, old length = $old_length, diff = $diff, discrepency = $calculated_diff\n";
print OUT ">$prev_chrom\n$new_string\n";

$seg_old_start = $prev_pos;
$seg_old_end = length($hash{$prev_chrom});

$seg_new_start = $start_mod;
$seg_new_end = $start_mod+$seg_old_end-$prev_pos; 	

my $temp1 = $seg_new_end - $seg_new_start;
my $temp2 = $seg_old_end - $seg_old_start;

print OUT2 "$chrom $seg_new_start $seg_new_end $seg_old_start $seg_old_end segment $temp1 $temp2\n";		



my $item;
foreach $item (keys %hash){
	if (exists ($hash2{$item})){
	}else{
		print "no modifications to $item\n"; #Nice - had me worried a second there...
		print OUT ">$item\n$hash{$item}\n";
		my $length = length($hash{$item});
		print OUT2 "$item 1 $length 1 $length segment $length $length\n";
	}
}

