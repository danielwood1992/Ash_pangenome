use POSIX;
use strict;

#NOTE: This is the version that works with the Tsebra gtf format

my $orthogroups = $ARGV[0];
#This will have the format
#OrthogroupName SR.Ind.Gene1.t1 SR.Ind.Gene2.t1 LR.Ind.Gene1.t1 etc.

my $ortho_folder = $ARGV[1];
my $gtf_list= $ARGV[2];
#The gtfs, from braker.gtf, will include lines with the following structure for each gene:

#Field: 0		 1		 2		 3	 4       5       6       7       8
#Scf9YQZ_100_HRSCAF_120  AUGUSTUS        transcript      58259   58690   1       -       .       g1.t1


`rm -r $ortho_folder`;
`mkdir $ortho_folder`;
my ($line, @temp, $orthogroup, $gene, $individual, $entry, @temp2, %hash);
open(IN, "<$orthogroups");

#This reads in the orthogroups: sets up a hash where each key is one of the genes, with the value being its Orthogroup
while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	@temp = split/ /, $line;
	$orthogroup = shift @temp;
	$orthogroup =~ s/://g; 
	foreach $entry (@temp){
		#Individual
		$individual = $entry;
		$individual =~ s/\..*/$1/;
#		print " $gene "; #So 
		$gene = $entry;
		@temp2 = split/g/, $gene;
		$gene = "g$temp2[1]";	
	
		$hash{$individual}{$gene} = $orthogroup; #So then for that individual you should be able to search for keys, genes, etc. and print out each as an orthologs file.
	}	
}

#Goes through the gtf list
my (@num_name, $line2, $file, $outfile, @temp2);
open(IN,  "<$gtf_list");
while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	@num_name = split/\t/, $line;
	$individual = "$num_name[0]";	
	#For each gtf...
	$file = $num_name[1];
	open(IN2, "<$file");
	print "$file\n";
	while(!eof(IN2)){
		$line2 = readline *IN2;
		chomp $line2;
		@temp = split/\t/, $line2;
		#Select lines that match the "transccript" pattern above
		if ($temp[2] eq "transcript"){
			#If the gene exists in the Orthogroups file
			if (exists ($hash{$individual}{$temp[8]})){
				print "$hash{$individual}{$temp[8]} ";
				#Opens the outfile for that orthogroup and adds a bed entry for the start/end of the transcript
				$outfile = "$ortho_folder/$hash{$individual}{$temp[8]}.bed";
				open(OUT, ">>$outfile");
				print OUT "$temp[0]\t$temp[3]\t$temp[4]\t$temp[8]\t$individual\t$hash{$individual}{$temp[8]}\n";
			}
		}
	}
}





