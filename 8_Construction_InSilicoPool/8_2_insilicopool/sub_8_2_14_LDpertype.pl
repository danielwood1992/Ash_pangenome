use POSIX;
use strict;

#Assumes: SNPs start with Scf, and SV entries start with something else...
#Input file looks like this
#
#Scf9YQZ_100_HRSCAF_120  18288   Scf9YQZ_100_HRSCAF_120:18288    Scf9YQZ_100_HRSCAF_120  148351  Scf9YQZ_100_HRSCAF_120:148351   0.783561
#Scf9YQZ_100_HRSCAF_120  18288   Scf9YQZ_100_HRSCAF_120:18288    Scf9YQZ_100_HRSCAF_120  167823  svim_asm.DEL.38658.Scf9YQZ_100_HRSCAF_120.167823        0.691176
#The SNP entries in field 5 will start with Scf; the SVs won't. So just filter based on this, easy peasy.


my $file = $ARGV[0];

#So assuming the file 

open(SV_SV, ">$file.SV_SV");
open(SV_SNP, ">$file.SV_SNP");
open(SNP_SNP, ">$file.SNP_SNP");

my ($line, @temp, $temp2, $temp5);

my $first = "T";
open(IN, "<$file");
while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	if ($first eq "T"){
		$first = "F";
		print SV_SV $line."\n";
		print SV_SNP $line."\n";
		print SNP_SNP $line."\n";
	}else{
		@temp = split/\t/, $line;
		#relevant fields are 2, 5
		$temp2 = "SV";
		$temp5 = "SV";
		if ($temp[2] =~ m/^Scf/){
			$temp2 = "SNP";
		}
		if ($temp[5] =~ m/^Scf/){
			$temp5 = "SNP";
		}

		if ($temp2 eq "SV" && $temp5 eq "SV"){
			print SV_SV $line."\n";
		}elsif($temp2 eq "SNP" && $temp5 eq "SNP"){
			print SNP_SNP $line."\n";
		}elsif(($temp2 eq "SNP" && $temp5 eq "SV") || ($temp2 eq "SV" && $temp5 eq "SNP")){
			print SV_SNP $line."\n";
		}else{
			die "wrong file format?";
		}
		
	}
}
	
