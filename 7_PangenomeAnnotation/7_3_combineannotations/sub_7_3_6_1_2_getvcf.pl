use POSIX;
use strict;

#Information to get the SVs used to convert the bed file
my $prefix = "/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_20_pangenome_annotation";
my $suffix = "PG2_20_2.vcf.PG2_20_2.temp1.txt.PG2_20_2.kept.vcf_lines.bed";
my $ind_list="/data/home/mpx545/scripts/PG2_RealData/PG2_5_ONTQC/filtered_reads_PG2_5_2.txt_nomandshurica.names";

#This is a file, e.g. OG0000.bed.0.txt: 
#Format like this
#Scf9YQZ_39_HRSCAF_57    6828719 6831538 g21622.t1       PG67    LR      OG0019422       6828719

my $input_file = $ARGV[0];
open(OUT, ">$input_file.SVs");
#How much memory would it take to just read every line in...probably quite a lot...

#I mean I guess the terrible alternative would be to concatenate and read in every bed file, but that does seem like madness. :q
my ($line, @temp, $var, $i, @temp2, @temp3, $to_print);

my %name_hash;
open(IN, "<$ind_list");

#Make a hash of names...
while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	$name_hash{$line} = "";
}

my ($start, $end, $chrom); #the start and end points of the gene...
my $first = "T";

open(IN, "<$input_file");

while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	@temp = split/\t/, $line;
#	print "$temp[0]\t$temp[1]\t$temp[2]\n";
	$temp[1] =~ s/\+.*//g;
	$temp[2] =~ s/\+.*//g;

	if ($first eq "T"){
		$start = $temp[1];
		$end = $temp[2];
		$chrom = $temp[0]; #they should all be on the same chromosome
		$first = "F";
	}

	if ($temp[1] < $start){
		#Not that this should happen...
		$start = $temp[1];
	}	

	if ($temp[2] > $end){
		$end = $temp[2];
	}

}

open(IN, "<$input_file");


while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	@temp = split/\t/, $line;
#	print "$temp[0]\t$temp[1]\t$temp[2]\n";
	$temp[1] =~ s/\+.*//g;
	$temp[2] =~ s/\+.*//g;

	$name_hash{$temp[4]} = "yes"; #so this individual does have a gene present...

	#Getting the overlap of the gene position with SVs for that individual...
	$var = `module load bedtools && echo -e "$temp[0]\t$temp[1]\t$temp[2]" | bedtools intersect -a - -b $prefix/$temp[4].$suffix -wa -wb`;
	#So then from the output of this, we want to get a list of the SVs involved I guess...
	@temp2 = split/\n/, $var;
	$i = 0;
	while ($i < scalar(@temp2)){
#		print $temp2[$i]."\n";
		@temp3 = split/\t/, $temp2[$i];
		$temp2[$i] = "$temp3[3];$temp3[4];$temp3[5];$temp3[6];$temp3[7]";
		$i++;
	}
	$to_print = join(":", @temp2);	
	print OUT "$line\t$to_print\n"; #So that seems to work then.
	#I guess the thing we can then work out is...whether they overlap...? Yes that would be easy as if they did overlap thanks to an SV, they would share that SV right?

}
my $item;
foreach $item (keys %name_hash){
	if ($name_hash{$item} eq "yes"){
		#So if there is a gene in there, do nothing
	}else{
		$var = `module load bedtools && echo -e "$chrom\t$start\t$end" | bedtools intersect -a - -b $prefix/$item.$suffix -wa -wb`;
	#So then from the output of this, we want to get a list of the SVs involved I guess...
	@temp2 = split/\n/, $var;
	$i = 0;
	while ($i < scalar(@temp2)){
#		print $temp2[$i]."\n";
		@temp3 = split/\t/, $temp2[$i];
		$temp2[$i] = "$temp3[3];$temp3[4];$temp3[5];$temp3[6];$temp3[7]";
		$i++;
	}
	$to_print = join(":", @temp2);	
	print OUT "$chrom\t$start\t$end\tNOGENE\t$item\tNA\tNA\tNA\t$to_print\n"; #So that seems to work then.
			
	}
}
