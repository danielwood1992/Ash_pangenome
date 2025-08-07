use POSIX;
use strict;
#Set progress tracking
#my $orthogroups = "/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_4_Annotation/PG2_4_10_orthofinder/OrthoFinder/Results_Apr26_1/Orthogroups/Orthogroups.txt.head";

#For combined stuff
#my $orthogroups = "/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_4_Annotation/PG2_4_10_orthofinder/OrthoFinder/Results_Apr26_1/Orthogroups/Orthogroups.txt";
#my $ortho_folder = "/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_4_Annotation/PG2_4_10_orthofinder/OrthoFinder/Results_Apr26_1/Orthogroups/PG2_4_4_10.1_outputs2";

#NOTE: This is the version that works with the Tsebra gtf format

my $orthogroups = $ARGV[0];
#This is the orthogroups.txt file produced from Orthofinder. The format of this is...
#Orthogroup name: Gene1 Gene2 Gene3 Gene4 etc.
#E.g.
#OG0000: LR.run10g1168.t1 LR.run10g11698.t1 etc. 

my $ortho_folder = $ARGV[1];
#This is just the output directory

my $gtf_list= $ARGV[2];

`rm -r $ortho_folder`;
`mkdir $ortho_folder`;
my ($line, @temp, $orthogroup, $gene, $individual, $entry, @temp2, %hash);
open(IN, "<$orthogroups");
while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	@temp = split/ /, $line;
	#Gets the orthogroup name, $orthogroup
	$orthogroup = shift @temp;
	$orthogroup =~ s/://g;
	#Each $entry will be something like LR.run10g11698.t1
	foreach $entry (@temp){
		#Get individual run name: 
		$individual = $entry;
		$individual =~ s/(run\d+).*/$1/; #So from LR.run10g11698.t1 this should give LR.run10
		#Get gene name
		$gene = $entry;
		@temp2 = split/g/, $gene;
		$gene = "g$temp2[1]"; #So from LR.run10g1168.t1 this should be g1168
		$hash{$individual}{$gene} = $orthogroup;
		#So this creates a hash of hashes: for each individual, for each gene, you can get the Orthogroup..
	}	
}

#Go through the list of gtf files...
#This has the structure SR\t1\t/path/to/file/braker.gtf
##
my (@num_name, $line2, $file, $outfile, @temp2);
open(IN,  "<$gtf_list");
while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	@num_name = split/\t/, $line;
	$individual = "$num_name[0].run$num_name[1]"; #This will be the individual run name, the same as in the has above	
	$file = $num_name[2];
	open(IN2, "<$file");
	print $file."\n";
	while(!eof(IN2)){
		$line2 = readline *IN2;
#		print $line2."\n";
		chomp $line2;
		#So this is going through the braker.gtf files, which have the structure
		#Chrom_Name\tAUGUSTUS\tgene|transcript|stop_codon etc.\tstart\tend\t.\t.\t-\ttranscript_name
		@temp = split/\t/, $line2;
		if ($temp[2] eq "transcript"){
			#Selecting the transcripts only
			#These have the same coordinates as the gene
			#If it has been assigned an orthogroup...creates or adds to a .bed file for that orthogroup
			#(specified by $hash{$individual}{$gene}, and adds this entry to the bed file
			#So you will have a bunch of bed files, one per orthogroup, with the positions in the genome
			if (exists ($hash{$individual}{$temp[8]})){
				#Cool so this seems to work, great
				#print "$hash{$individual}{$temp[8]} ";
				$outfile = "$ortho_folder/$hash{$individual}{$temp[8]}.bed";
				open(OUT, ">>$outfile");
				print OUT "$temp[0]\t$temp[3]\t$temp[4]\t$temp[8]\t$individual\t$hash{$individual}{$temp[8]}\n";
			}
		}
	}
}





