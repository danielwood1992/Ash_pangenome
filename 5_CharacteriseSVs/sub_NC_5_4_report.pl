use POSIX;
use strict;

#What would we like? 
#Number of SVs? Number of repeats?
#Overlap: per class...
#OVerlap: total...

my $genome="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_4_Annotation/RM_Stuff/RM_200791.MonFeb61712262023/consensi.fa.classified.tmp.repeatmask.RepeatMod_plus_Laura.noLowSoftMask/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta.out.bed";

my ($line, @temp, %hash, $length);


open(IN, "<$genome");
while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	@temp = split/\t/, $line;

	$temp[3] =~ s/\/.*//g;
	$temp[3] =~ s/://g;
	$temp[3] =~ s/\?//g;
	$length = $temp[2]-$temp[1];

	$hash{"genome"}{$temp[3]} = $hash{"genome"}{$temp[3]}+$length;
	$hash{"genome"}{"total"} = $hash{"genome"}{"total"}+$length;

}




my $file = "/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_8_vg/complete_merged_PG2_12_2.all_types.all_types.tags.3.vcf.repeat_overlap";
open(OUT, ">$file.summary");

open(IN, "<$file");
while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	@temp = split/\t/, $line;
	$temp[8] =~ s/\/.*//g;
	$temp[8] =~ s/://g;
	$temp[8] =~ s/\?//g;
	
	$hash{"all"}{$temp[8]} = $hash{"all"}{$temp[8]}+$temp[9];
	$hash{"all"}{"total"} = $hash{"all"}{"total"}+$temp[9];

	$hash{$temp[4]}{$temp[8]} = $hash{$temp[4]}{$temp[8]}+$temp[9];
	$hash{$temp[4]}{"total"} = $hash{$temp[4]}{"total"}+$temp[9];
}

my ($sv_type, $repeat_type, $pc);
foreach $sv_type (keys %hash){
	foreach $repeat_type (keys %{ $hash{"genome"} }){
		$pc = 100*$hash{$sv_type}{$repeat_type} / $hash{$sv_type}{"total"};
		$pc = sprintf("%.2f", $pc);
		print OUT "$sv_type\t$repeat_type\t$hash{$sv_type}{$repeat_type}\t$pc\n";
	}
	print "######\n";
}



