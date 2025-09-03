use POSIX;
use strict;
#I guess step 1 we need to ask is: are there further genes that need to be split, i.e. ones that are inside SVs? 

#Note: this method assumes that two overlapping genes that are the same ortholog, but don't overlap inside the SV, are the same gene.
#May need to iron this out at a later stage I guess?
#

my $file = $ARGV[0];
open(OUT, ">$file.SVsGenes");
my ($line, @temp, %sv, %has_gene, %lacks_gene, %has_gene_svs, %lacks_gene_svs, $item, @temp2, $gene_num);
my $type = "extra"; 
#Column with type, where the type will either be "extra" (an extra gene from the reference), or "missing", a missing gene from the reference.
my $all_present = "T";
open(IN, "<$file");
while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	@temp = split/\t/, $line;
	
	if ($temp[4] eq "LR_SR"){
		$type = "missing";
	}
	
	@temp2 = split/:/, $temp[8];
	if ($temp[3] eq "NOGENE"){
		$all_present = "F"; #makes note that some are missing
		$lacks_gene{$temp[4]} = ""; #Notes whih individuals have no gene in this region
	
		foreach $item (@temp2){
			$sv{$item}++; #adds SV to the list
			$lacks_gene_svs{$item}{$temp[4]} = ""; #adds that individual to the list, for that SV, of genes present

		}

	}else{
		$has_gene{$temp[4]} = ""; #notes which individuals have a gene present in this region

		foreach $item (@temp2){
			$sv{$item}++; #adds to the list of SVs
			$has_gene_svs{$item}{$temp[4]} = "";
	
		}
	}
}
#So then we have for each SV, which individuals have it, which individuals don't, and which individuals have the gene, and which individuals don't. 
my $sv_in_present;
my $sv_in_absent;

my ($N_nogene, $N_gene, $N_nogene, $N_SV, $N_SV_Gene, $N_NSV_Gene, $N_SV_NGene, $N_NSV_NGene);


#So let's say we want...
#N_Genes\tN_NoGenes\tN_SVs\tSV+Gene, NoSV+Gene, SV+NoGene, NoSV+NoGene

if ($all_present eq "T" && $type eq "missing"){
	print OUT "$file\tAR\t51\tNA\tNA\tNA\tNA\tNA\tNA\tNA\n";
	#So this means: if all the individuals are represented, including the reference...
}else{
	#So then if this ins't true, some individuals miss the gene - either the reference, or not...

	if ($type eq "missing"){
	#If the reference sequence is present, this would suggest we are looking for SVs in the genes where it's absent.
		if (keys %lacks_gene_svs == 0){
				$N_nogene = keys %lacks_gene; #This is how many individuals lack the gene
				$N_gene = keys %has_gene; #This is how many individuals have the gene
				$N_SV = 0;
				$N_SV_Gene = 0;
				$N_NSV_Gene = $N_gene;
				$N_SV_NGene = 0;
				$N_NSV_NGene = $N_nogene;				

				print OUT "$file\tR_NSV\t$N_gene\t$N_nogene\t$N_SV\t$N_SV_Gene\t$N_NSV_Gene\t$N_SV_NGene\t$N_NSV_NGene\tNA\n";
#				print OUT "$file\tR_NSV\t$gene_num\tNA\tNA\tNA";
		
		}

		foreach $item (keys %lacks_gene_svs){
				#So for each SV, where the reference gene is missing...
				$N_nogene = keys %lacks_gene;
				$N_gene = keys %has_gene;
				$N_SV = $sv{$item}; 
				$N_SV_Gene = keys %{ $has_gene_svs{$item} }; #Number of indivividuals for that SV that have the gene
				$N_SV_NGene = keys %{ $lacks_gene_svs{$item} }; #Number of indivividuals for that SV that have the gene
				#So then we want...
				$N_NSV_Gene = $N_gene - $N_SV_Gene ;  #So this should just be the number of genes - number of genes with SV, right?
				$N_NSV_NGene = $N_nogene - $N_SV_NGene; #And this should just be the number of lacks genes - number of lacks genes with SV, right?

				print OUT "$file\tR_SV\t$N_gene\t$N_nogene\t$N_SV\t$N_SV_Gene\t$N_NSV_Gene\t$N_SV_NGene\t$N_NSV_NGene\t$item\n";


#				print OUT "$file\tR_SV\t$gene_num\t$sv_in_absent\t$sv_in_present\t$item\n";	
				#So for example...
				#OG0001.txt ref_gene_missing 
		}


	}else{
		#If the reference is missing, this indicates it's an extra gene we need to find an SV to associate it with...
		if (keys %has_gene_svs == 0){
			#So if you have an extra gene in some individuals, and none of them overlap an SV
			$N_nogene = keys %lacks_gene;
			$N_gene = keys %has_gene;


			$N_nogene = keys %lacks_gene; #This is how many individuals lack the gene
			$N_gene = keys %has_gene; #This is how many individuals have the gene
			$N_SV = 0;
			$N_SV_Gene = 0;
			$N_NSV_Gene = $N_gene;
			$N_SV_NGene = 0;
			$N_NSV_NGene = $N_nogene;				

			print OUT "$file\tNR_NSV\t$N_gene\t$N_nogene\t$N_SV\t$N_SV_Gene\t$N_NSV_Gene\t$N_SV_NGene\t$N_NSV_NGene\tNA\n";


		}else{
			#So if the gene is not present in the reference, and some SVs overlap the genes where it is present....
			foreach $item (keys %has_gene_svs){
				#So this is the SV then...

				$N_gene = keys %has_gene;
				$N_SV = $sv{$item}; 
				$N_nogene = keys %lacks_gene;

				$N_SV_Gene = keys %{ $has_gene_svs{$item} }; #Number of indivividuals for that SV that have the gene
				$N_NSV_Gene = $N_gene - $N_SV_Gene ;  #So this should just be the number of genes - number of genes with SV, right?

				$N_SV_NGene = keys %{ $lacks_gene_svs{$item} }; #Number of indivividuals for that SV that have the gene
				$N_NSV_NGene = $N_nogene - $N_SV_NGene; #And this should just be the number of lacks genes - number of lacks genes with SV, right?


				#So then we want...

				print OUT "$file\tNR_SV\t$N_gene\t$N_nogene\t$N_SV\t$N_SV_Gene\t$N_NSV_Gene\t$N_SV_NGene\t$N_NSV_NGene\t$item\n";

			}
		}
	}		

}

