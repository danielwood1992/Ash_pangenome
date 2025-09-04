use POSIX;
use strict;

#So the input file looks like this:
#0			    1       2       3        4       5         6           7          8            9
#Orthogroup		    Type    N_gene  N_nogene N_SV    N_SV_Gene N_NSV_Gene  N_SV_NGene N_NSV_NGene  SV
#OG0000011.bed.1.txt.SVs    NR_SV   1       49       25      1         0           24         25           Scf9YQZ_100_HRSCAF_120;28972115;28973332;DEL;-1217

my $file = $ARGV[0];
open(OUT, ">$file.F1");
open(IN, "<$file");
my ($line, @temp, %hash, $F1);
while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	@temp = split/\t/, $line;
	#Only calculate for when an SV is present to make an association
	if ($temp[1] eq "R_SV" || $temp[1] eq "NR_SV"){
	
		#Calculating an F1 score for how well an SV explains the presence/absence of a gene		
		#Formula for F-score: True Positive(True Positive + 0.5*(False Positive + False Negative)

		#For a gene being absent, the "true positives" is the gene co-occuring with the SV ($temp[7])
		#False positives: times when the gene is absent, but the SV is also absent ($temp[8])
		#False negatives: times when the gene is present, but the SV is present ($temp[5])
		if ($temp[1] eq "R_SV"){
			#For a gene being del
			$F1 = $temp[7]/($temp[7] + 0.5*$temp[8] + 0.5*$temp[5]);
		

		#For a gene being present, the "true positives" is the gene co-occuring with the SV ($temp[5])
		#False positives: times when the gene is absent, but the SV is present ($temp[7])
		#False negatives: times when the gene is present, but the SV is absent ($temp[5])
		}elsif($temp[1] eq "NR_SV"){
			$F1 = $temp[5]/($temp[5] + 0.5*$temp[7] + 0.5*$temp[6]);

		}
	
			print "$line\t$F1\n";
		if (exists $hash{$temp[0]}){
			if ($F1 > $hash{$temp[0]}[1]){
				$hash{$temp[0]}[0] = $line;
				$hash{$temp[0]}[1] = $F1;	
			}
		}else{
			$hash{$temp[0]}[0] = $line;
			$hash{$temp[0]}[1] = $F1;
			#So I guess we're treating the number of genes as the true thing
			#The "true" positives are the number of genes in the ref (should be the same across examples)
			#The number of "false positives" are the number of instances where the gene/lack is present, and SV is absent...?
		}					

	}else{
		$hash{$temp[0]}[0] = $line;
		$hash{$temp[0]}[1] = "NA";
	}
}
my ($item);
foreach $item (keys %hash){
	print OUT "$hash{$item}[0]\t$hash{$item}[1]\n";
}
	
