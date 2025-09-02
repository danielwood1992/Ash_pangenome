use POSIX;
use strict;


my $file = $ARGV[0]; #This is the list of bed locations for SVs

my $file2 = $ARGV[1]; #This is the list of overlapping bed locations for SVs

#Examples
#my $file = "/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_12_merge/DW-S01_PG65.PG2_12_1_results.txt.1_AND_2_OR_4.all_types.vcf.PG2_20_2.temp2.txt";
#my $file2 = "/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_12_merge/DW-S01_PG65.PG2_12_1_results.txt.1_AND_2_OR_4.all_types.vcf.PG2_20_2.temp1.txt";

open(IN, "<$file"); #Read in file with overlaps
my ($line, $name1, $name2, @temp, %to_remove);
#Sets up a hash of SVs to remove:


while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	@temp = split/\t/, $line;
	
	#Name1 and Name2 are the bed entries for overlaps in this file
	$name1 = "$temp[0]\t$temp[1]\t$temp[2]\t$temp[3]\t$temp[4]";
	$name2 = "$temp[5]\t$temp[6]\t$temp[7]\t$temp[8]\t$temp[9]";

	#Ignore those that match (every entry will overlap with itself)
	if ($name1 eq $name2){
		#But if both are tandem duplicates, might as well get rid of them here,
		#as they won't get included in the pangenome anyway
		if ($temp[3] eq "DUP"){
			$to_remove{$name1} = "$name1\t$name2\tRemove1";
		}
	}else{
		if ($temp[3] eq "INS"){
			if ($temp[8] eq "DEL" | $temp[8] eq "DUP" | $temp[8] eq "INV"){
				#Remove the other variant
				$to_remove{$name2} = "$name1\t$name2\tRemove2";
			}elsif($temp[8] eq "INS"){
				#Keep whichever is bigger
				if ($temp[4] > $temp[9]){
					$to_remove{$name2} = "$name1\t$name2\tRemove2";
				}else{
					$to_remove{$name1} = "$name1\t$name2\tRemove1";
				}
			}
			
		}elsif($temp[3] eq "DEL" | $temp[3] eq "INV"){
			if ($temp[8] eq "DEL" | $temp[8] eq "INV"){
				#Keep whichever is longest
				if ($temp[4] > $temp[9]){
					$to_remove{$name2} = "$name1\t$name2\tRemove2";
				}else{
					$to_remove{$name1} = "$name1\t$name2\tRemove1";
				}

			}elsif($temp[8] eq "DUP"){
				#Keep the deletion or inversion
				$to_remove{$name2} = "$name1\t$name2\tRemove2";
			}elsif($temp[8] eq "INS"){
				#Keep the insertion
				$to_remove{$name1} = "$name1\t$name2\tRemove1";

			}
		
		}elsif($temp[3] eq "DUP"){
			if ($temp[8] eq "DEL" | $temp[8] eq "INV" | $temp[8] eq "INS"){
				#Keep the other one
				$to_remove{$name1} = "$name1\t$name2\tRemove1";
			}elsif($temp[8] eq "DUP"){
				#Remove both
				$to_remove{$name1} = "$name1\t$name2\tRemove12";
				$to_remove{$name2} = "$name1\t$name2\tRemove12";
			}elsif($temp[8] eq "INS"){
				#Keep the insertion
				$to_remove{$name1} = "yep";
			}


		}else{
			die "\$temp[3] not recognised as DEL,INS,DUP,or INV: $temp[3]\n";
		}
	}
}
print "\n";
#$file2 = $ARGV[1];
open(IN, "<$file2");
open(OUT, ">$file2.PG2_20_2.kept");
open(OUT2, ">$file2.PG2_20_2.removed");
while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	@temp = split/\t/, $line;
	$name1 = "$temp[0]\t$temp[1]\t$temp[2]\t$temp[3]\t$temp[4]";
	if (exists ($to_remove{$name1})){
		print OUT2 $to_remove{$name1}."\n";
	}else{
		print OUT $line."\n";
	}
}
