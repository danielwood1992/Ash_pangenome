use POSIX;
use strict;

#Very similar to other script

my $AD_file = $ARGV[0];
my $MAF_file = $ARGV[1];

my ($line, @temp, %hash);

open(IN, "<$MAF_file");
while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	@temp = split/\t/, $line;
	$hash{"$temp[0].$temp[1]"} = $temp[2];
}

open(OUT, ">$AD_file.PG2_25_10.out");

my ($sum, @temp2, $AD_prop, $N_A, $N_R);

open(IN, "<$AD_file");
while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	@temp = split/\t/, $line;
	if (exists $hash{"$temp[0].$temp[1]"}){
		
		if ($temp[2] eq "."){
			$AD_prop = "NA";
		}else{
			@temp2 = split/,/, $temp[2];
			$sum = $temp2[0]+$temp2[1]+$temp2[2]+$temp2[3];
			$N_R = $temp2[0]+$temp2[1];
			$N_A = $temp2[2]+$temp2[3];
			if ($sum eq 0){
				$AD_prop = "NA";
			}else{
		
		#Not really sure why these are all commented out...?

		#		if ($N_R > $N_A){
					$AD_prop = $N_A/$sum;
		#		}else{
		#			$AD_prop = $N_R/$sum;
		#		}

			}


			my $MAF = $hash{"$temp[0].$temp[1]"};
			print OUT "$temp[0]\t$temp[1]\t$MAF\t$AD_prop\n";
		}
	}
}
