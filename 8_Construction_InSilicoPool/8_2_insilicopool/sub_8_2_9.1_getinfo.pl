use POSIX;
use strict;
#Not sure why I didn't just use bcftools query...

my ($line, @temp, @temp2, $i, $N_AD, $N_GT,$AD, $GT, @temp3, $item, @temp4, $DP);
open(IN, "<$ARGV[0]");
open(OUT, ">$ARGV[0].adstats");
#So this gets the i) AD (allele dpeth) and ii) GT numbers from the vcf.

while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	if ($line =~ m/^#/){
	}else{
		@temp = split/\t/, $line;
		@temp2 = split/:/, $temp[8];
		$i = 0;
		#This just identifies which positions in the FORMAT field corresponds to AD and GT
		foreach $item (@temp2){
			if ($item =~ m/^AD$/){
				$N_AD = $i;
			}
			if ($item =~ m/^GT$/){
				$N_GT = $i;
			}		
			$i++;
		}
		#So having established this...
		@temp3 = split/:/, $temp[9];
		$AD = $temp3[$N_AD]; #gets the AD value
		$GT = $temp3[$N_GT]; #gets the GT value
#		print $AD."\n";	
		@temp4 = split/,/, $AD; #So this is just the AD for the i) ref and ii) alt alleles I guess, in $temp4[0] and $temp4[1]
		$DP = $temp4[0]+$temp4[1];
		#So then the output format is Chrom Pos SV_Name Genotype Depth RefDepth AltDepth File 
		print OUT "$temp[0]\t$temp[1]\t$temp[2]\t$GT\t$DP\t$temp4[0]\t$temp4[1]\t$ARGV[0]\n";
	}	
}
