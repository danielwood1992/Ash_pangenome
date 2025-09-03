use POSIX;
use strict;

my $orthogroups = $ARGV[0];
#This is the Orthogroups file:
#OG0000.txt: gene1 gene2 gene3 etc.
my $ortho_folder = $ARGV[1];
my $gtf_list= $ARGV[2];
#This is the list of gtfs

`rm -r $ortho_folder`;
`mkdir $ortho_folder`;
my ($line, @temp, $orthogroup, $gene, $individual, $entry, @temp2, %hash);

#Part 1 - aim to produce a hash with $hash{$individual}{$gene} = $orthogroup
#So you can assign genes from each individuals gtfs to an orthogroup
open(IN, "<$orthogroups");
while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	@temp = split/ /, $line;
	$orthogroup = shift @temp;
	$orthogroup =~ s/://g; #gets the Orhtogroup names
	foreach $entry (@temp){
		#Individual
		$individual = $entry;
		@temp2 = split/\./, $individual;

		#the genes from BATG-1.0 referece include the word "run": 
		if ($temp2[1] =~ m/run/){
			$individual = "LR_SR\tLR_SR";
			$gene = $entry;
			@temp2 = split/g/, $gene;
#			$gene = "g$temp2[1]";	
			print "$individual\t$gene\n";
			$hash{$individual}{$gene} = $orthogroup; .
		#For the other genes, convert: I think this is 
		}else{
			$individual = "$temp2[1]\t$temp2[0]"; #For the ONT samples, this corresponds to LR/SR and IndividualName
#			print " $gene "; #So 
			$gene = $entry;
			@temp2 = split/g/, $gene;
			$gene = "g$temp2[1]"; #This is the gene name
#			print "$individual $gene\n";
			$hash{$individual}{$gene} = $orthogroup; #Will be able to return the Orthogroup for a given individual + gene
		}
	}	
}


print "woof\n";
#So then we need to go through each of the GTF files, right?
open(IN,  "<$gtf_list");
while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	@num_name = split/\t/, $line;
	$individual = "$num_name[0]\t$num_name[1]";
	$file = $num_name[2];
	open(IN2, "<$file");
	#If the individual matches LR_SR, I think the patterns atre slightly different
	if ($individual eq "LR_SR\tLR_SR"){
		print $file." LR_SR \n";	


			while(!eof(IN2)){
			$line2 = readline *IN2;
			chomp $line2;
			@temp = split/\t/, $line2;
			my $gene = "$temp[7]"."$temp[6]";
			if (exists ($hash{$individual}{$gene})){
				print "yep\n";
				$outfile = "$ortho_folder/$hash{$individual}{$gene}.bed";
				open(OUT, ">>$outfile");
				print OUT "$temp[0]\t$temp[1]\t$temp[2]\t$temp[6]\t$individual\t$hash{$individual}{$gene}\n";
			}
		}
	


	#If it's for the ONT samples, the pattern is slightly different as they are more raw files
	}else{
		print "$file\n";
			while(!eof(IN2)){
			$line2 = readline *IN2;
#			print $line2."\n";
			chomp $line2;
			@temp = split/\t/, $line2;
			if ($temp[3] =~ m/^transcript/){
				@temp3 = split/_/, $temp[3];
				if (exists ($hash{$individual}{$temp3[1]})){
					$outfile = "$ortho_folder/$hash{$individual}{$temp3[1]}.bed";
					open(OUT, ">>$outfile");
					print OUT "$temp[0]\t$temp[4]\t$temp[5]\t$temp3[1]\t$individual\t$hash{$individual}{$temp3[1]}\n";
				}
			}
		}
	}
}
#Output is an individual bed file for each gene, in the reference coordinates
