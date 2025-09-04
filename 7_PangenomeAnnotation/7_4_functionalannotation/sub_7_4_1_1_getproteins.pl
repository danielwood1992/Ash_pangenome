use POSIX;
use strict;

#I think I must have manually listed the text files...
#This is just a list of the gene text files, OG000000.bed.0.txt etc.
my $file_list = "/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_20_pangenome_annotation/PG2_4_4_2/PG2_20_5_toOrthofind_2/OrthoFinder/Results_Jun24/Orthogroups/PG2_20_5/text_files_list";

#Finds thwe Orthogroup sequences Orthofinder produces
my $fa_prefix = "/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_20_pangenome_annotation/PG2_4_4_2/PG2_20_5_toOrthofind_2/OrthoFinder/Results_Jun24/Orthogroup_Sequences";
my $fa_suffix = "fa";
#Output file
open(OUT, ">$file_list.PG2_20_10.out");

my ($file, $file_name1, $file_name2, $line, @temp);
my ($file_name, %hash, $ref, $name, $seq, $length, $temp_name, $to_print);
open(IN, "<$file_list");

#Read gene files: get name
while(!eof(IN)){
	$file = readline *IN;
	chomp $file;
	if ($file =~ m/\//){
	}else{ 
		"die bad file format\n";
	}
	open(IN2, "<$file");
	$file_name1 = $file;
	$file_name1 =~ s/.*\///g;
	$file_name2 = $file_name1;
	$file_name2 =~ s/\..*//g;
	print $file."\n";
	print $file_name1."\n";
	print $file_name2."\n";
	
	%hash = ();
	$ref = "F";
	#Gets a hash of ind/gene identifiers
	#The file it's reading has the format:
	#Scf9YQZ_39_HRSCAF_57    6828719 6831538 g21622.t1       PG67    LR      OG0019422       6828719

	while(!eof(IN2)){
		$line = readline *IN2;
		chomp $line;
		@temp = split/\t/, $line;
		$hash{"$temp[3].$temp[4]"} = $file_name; #This is gene_name.sample_name
		if ($temp[4] eq "LR_SR"){
			$ref = $temp[3];
			print "ref\t$ref\n";
		}	
	}
	#This is just deleting blank lines, not quite sure why it's there
	`perl -ni -e 'print unless /^\\s*\$/' $fa_prefix/$file_name2.$fa_suffix`;
	
	#This runs through the fasta file to look for the genes identified
	#Seems a bit mad to read the whole thing through for every gene but there you go
	open(IN2, "<$fa_prefix/$file_name2.$fa_suffix");
	while(!eof(IN2)){
		#If the gene is in BATG-1.0, just use this one: otherwise, use the longest proteins sequence from the ONT samples
		if ($ref eq "F"){
			$name = readline *IN2;
			chomp $name;
			if ($name eq ""){
				$name = readline *IN2;
			}
			$seq = readline *IN2;
			chomp $seq;

			$length = ""; 
			if ($name =~ m/^>/){
			}else{
				die "fa formatting error $fa_prefix/$file_name2.$fa_suffix $name $seq\n";
			}
			@temp = split/\./, $name;
			if (exists $hash{"$temp[2].$temp[3].$temp[1]"}){
				if (length($seq) > $length){
					$to_print = "$name.$file_name1\n$seq\n"; #Onl including the longest protein sequence per gene
				}	
			}	

		}else{
			$name = readline *IN2;
			$seq = readline *IN2;
			chomp $name;
			chomp $seq;
			if ($name =~ m/run/){
				$temp_name = $name;
				$temp_name =~ s/^.*g/g/g;
#				print $temp_name."\n";
				if ($temp_name eq $ref){
					print "$temp_name\n";
					$to_print = "$name.$file_name1\n$seq\n";
				}		

			}
		}		
	
		
	}
	print "\n";
	print $to_print."\n";
	print OUT $to_print;
}

#Copies output file to new location
`cp $file_list.PG2_20_10.out /data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_26_FunctionalAnnotation/protein_seqs_PG2_20_complete.fasta"
