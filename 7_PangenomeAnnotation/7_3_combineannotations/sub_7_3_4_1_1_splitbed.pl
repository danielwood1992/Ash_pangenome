use POSIX;
use strict;

my $prefix = "/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_20_pangenome_annotation";
my $suffix = "PG2_20_2.vcf.PG2_20_2.temp1.txt.PG2_20_2.kept.vcf_lines.bed.mod.fasta.conversion_bed";

#my $input_file = "/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_20_pangenome_annotation/PG2_4_4_2/PG2_20_5_toOrthofind_2/OrthoFinder/Results_Jun24/Orthogroups/OG0000020.bed";

my $input_file = $ARGV[0];

#How much memory would it take to just read every line in...probably quite a lot...

#I mean I guess the terrible alternative would be to concatenate and read in every bed file, but that does seem like madness. :q
`cut -f2 $input_file | sed "s/+.*//g" > $input_file.col2 && paste $input_file $input_file.col2 | sort -k1,1 -k8,8n > $input_file.col2.temp`;
#So it's sorted by chromosome, then by starting position )removing any SVs present I hope...

my $i = 0;
my ($line, $prev_end, $prev_chrom, @temp);
my (@array, $line);
my $first = "T";

open(IN, "<$input_file.col2.temp");
open(OUT, ">$input_file.$i.txt");

while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	@temp = split/\t/, $line;
	$temp[1] =~ s/\+.*//g;
	$temp[2] =~ s/\+.*//g;

#	print $line."\n";
	if ($first eq "T"){
		$prev_end = $temp[2];
		$prev_chrom = $temp[0];	
		$first = "F";
		print OUT $line."\n";
	}else{
		#So if the next start site is less than the previous end site...it's still part of the gene
	
		if ($temp[0] eq $prev_chrom){

			if ($temp[1] <= $prev_end){
				#So if the chrom is the same, and the start is less than the end, print this out
				$prev_chrom = $temp[0];

				print OUT $line."\n";
				if ($temp[2] > $prev_end){
					#If the new gene extends further than the oldest one, extend the end...
					$prev_end = $temp[2]; 
				}
			}else{
				$i++;
				close OUT;
				open(OUT, ">$input_file.$i.txt");
				print OUT $line."\n";
				$prev_chrom = $temp[0];
				$prev_end = $temp[2];
			}		
		#ELSE: if it's a different chromosome to previous, print the old stuff out and start a new line?
		}else{
				#PRINT A NEW GENE 
			$i++;
			close OUT;
			open(OUT, ">$input_file.$i.txt");
			print OUT $line."\n";

			$prev_chrom = $temp[0];
			$prev_end = $temp[2];

		}
	}
	#So for a normal site...
}	


