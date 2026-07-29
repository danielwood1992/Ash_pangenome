use POSIX;
use strict;
#Removes SVs from contamination list...

my $vcf = "/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_12_merge/complete_merged_PG2_12_2.all_types.all_types.tags.vcf.uniqnames.reffixed2.1";
my $contams = "/data/home/mpx545/scripts/PG2_RealData/PG2_12_SVMerging/041023_contams.csv";

my ($line, @temp, %hash, $first);
$first = "T";

open(IN1, "<$contams");
while(!eof(IN1)){
	$line = readline *IN1;
	chomp $line;
	if ($first eq "T"){
		$first = "F";
	}else{
		@temp = split/,/, $line;
		$hash{$temp[-1]} = "";
		print $temp[-1]."\n";
	}
}

open(IN2, "<$vcf");
open(OUT, ">$vcf.filt1");
while(!eof(IN2)){
	$line = readline *IN2;
	chomp $line;
	if ($line =~ m/^>/){
		print OUT $line."\n";
	}else{
		@temp = split/\t/, $line;
		if (exists($hash{$temp[2]})){
		}else{
			print OUT $line."\n";
		}
	}
}

print "Before\n";
`wc -l $vcf`;
print "After\n";
`wc -l $vcf.filt1`;
