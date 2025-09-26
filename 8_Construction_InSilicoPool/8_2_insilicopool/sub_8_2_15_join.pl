use POSIX;
use strict;

my $AD_file = $ARGV[0];
#This is the vcf from the artificial pool
#Looks a bit like this: 
#Just has the position, SV name, and then comma separated reads supporting the ref/alt allele
#Scf9YQZ_1007_HRSCAF_1031        22982   cuteSV.DEL.0.Scf9YQZ_1007_HRSCAF_1031.22982     0,0
#Scf9YQZ_1007_HRSCAF_1031        23679   svim_asm.INS.40212.Scf9YQZ_1007_HRSCAF_1031.23679       0,0
#Scf9YQZ_1007_HRSCAF_1031        28972   svim_asm.DEL.40063.Scf9YQZ_1007_HRSCAF_1031.28972       86,1

my $MAF_file = $ARGV[1];
#This is the vcf from the merged individual vcf calls - the final entry here just gives the AF
#Scf9YQZ_100_HRSCAF_120  38294   svim_asm.DEL.38643.Scf9YQZ_100_HRSCAF_120.38294 0.146341
#Scf9YQZ_100_HRSCAF_120  113617  svim_asm.INS.37998.Scf9YQZ_100_HRSCAF_120.113617        0.0952381
#Scf9YQZ_100_HRSCAF_120  120397  svim_asm.INS.38234.Scf9YQZ_100_HRSCAF_120.120397        0.131579

my ($line, @temp, %hash);

#Makes a hash of positions called from the merged individual calls:
#Note this is the second file we're using first, for some reason

open(IN, "<$MAF_file");
while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	@temp = split/\t/, $line;
	$hash{"$temp[0].$temp[1].$temp[2]"} = $temp[3];
}

open(OUT, ">$AD_file.PG2_25_10.out");

my ($sum, @temp2, $AD_prop);

open(IN, "<$AD_file");

#Reads through the file - finds the equivalent
while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	@temp = split/\t/, $line;
	if (exists $hash{"$temp[0].$temp[1].$temp[2]"}){
		@temp2 = split/,/, $temp[3];

		$sum = $temp2[0]+$temp2[1];
		if ($sum eq 0){
			$AD_prop = "NA";
		}else{
			$AD_prop = $temp2[1]/$sum; #So this is getting the alt allele frequency as it's ref,alt
		}
		my $MAF = $hash{"$temp[0].$temp[1].$temp[2]"};
		print OUT "$temp[0]\t$temp[1]\t$temp[2]\t$MAF\t$AD_prop\n";
	}
}
