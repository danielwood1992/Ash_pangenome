use POSIX;
use strict;

#Script purpose:
#
#The gene names used for the analysis are a bit confusing so this script will take the gtf and rename them for future work. 
#The intial gtf for this is called
#LR_SR.PG2_4_4_10.2.results.longest.bed.final.gtf.trimmed
#Sample lines

#Scf9YQZ_1006_HRSCAF_1030        AUGUSTUS        stop_codon      696     698     .       -       0       transcript_id "g1.t1"; gene_id "g1";    LR.run7
#Scf9YQZ_1006_HRSCAF_1030        AUGUSTUS        CDS     696     1757    1       -       0       transcript_id "g1.t1"; gene_id "g1";    LR.run7
#Scf9YQZ_1006_HRSCAF_1030        AUGUSTUS        exon    696     1757    .       -       .       transcript_id "g1.t1"; gene_id "g1";    LR.run7
#Scf9YQZ_1006_HRSCAF_1030        AUGUSTUS        gene    696     1757    .       -       .       g1      LR.run7
#Scf9YQZ_1006_HRSCAF_1030        AUGUSTUS        transcript      696     1757    1       -       .       g1.t1   LR.run7
#Scf9YQZ_1006_HRSCAF_1030        AUGUSTUS        start_codon     1755    1757    .       -       0       transcript_id "g1.t1"; gene_id "g1";    LR.run7
#Scf9YQZ_100_HRSCAF_120  AUGUSTUS        stop_codon      60990   60992   .       -       0       transcript_id "g2.t1"; gene_id "g2";    LR.run9
#
#Note - each "gene name" may not be unique - it is the gene name that each run (in column 10) produced. These are combined downstream. 
#
#Will update these in order to a new format:
#
#FexB00001, FexB00002 etc.
#
#Also note: the input fields in column 9 (which need to be changed) only follow the pattern...
#g
#g.t
#transcript_id "g.t"; gene_id "g";#

my $file = "/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_4_Annotation/PG2_4_9.4_orthofinder/OrthoFinder/Results_Feb23_1/Orthogroups/PG2_4_4_10.2/LR_SR.PG2_4_4_10.2.results.longest.bed.final.gtf.trimmed";

my ($line, @temp, $run_ID, $gene_name, $new_gene, %old_genes, $i, $id, $gene_name_replace);
$i = 1;
open(IN, "<$file");
open(OUT1, ">$file.conversion_key");
open(OUT2, ">$file.converted.gtf");

while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	@temp = split/\t/, $line;
	
	$run_ID = $temp[9];
	#print $run_ID."\n";

	#Get old gene name
	$gene_name = $temp[8];
	$gene_name =~s/\..*//g;
	$gene_name  =~ s/"//g;
	$gene_name =~ s/.* //g;
	if ($gene_name =~ /(g\d+)/) {
	}else{
		die "Unexpected column 9 - format error: $line\n";
	}
	#	print $gene_name."\n";
	$gene_name_replace = $gene_name;
	$gene_name = "$run_ID$gene_name";

	if (exists($old_genes{$gene_name})){
		$new_gene = $old_genes{$gene_name};
	}else{
		$id = sprintf("%05d", $i);
		$old_genes{$gene_name} = "FexB$id";
		print OUT1 "$gene_name\t$old_genes{$gene_name}\n";
		$i++;
	}
	#print "$gene_name $old_genes{$gene_name}\n";
	$temp[8] =~ s/$gene_name_replace/$old_genes{$gene_name}/g;
	$line = join("\t", @temp[0..8]);
	print OUT2 "$line\n";
}

#While we are here we may as well rename the amino acid file used for downstream analysis

my $aa = "/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_4_Annotation/PG2_4_9.4_orthofinder/OrthoFinder/Results_Feb23_1/Orthogroups/PG2_4_4_10.2/LR_SR.PG2_4_4_10.2.results.longest.bed.trimmed.aa.fasta";

my ($name, $seq);

open(IN, "<$aa");
open(OUT3, ">$aa.converted.fa");
while(!eof(IN)){
	$name = readline *IN;
	chomp $name;
	$seq = readline *IN;
	chomp $seq;
	if ($name !~ m/^>/){
		die "wrong file format for aa file; expected not interleaved";
	}else{
		@temp = split/\./, $name;
		$temp[0] =~ s/>//g;
		if (exists $old_genes{"$temp[0].$temp[1]"}){
			print "$temp[0].$temp[1]\t".$old_genes{"$temp[0].$temp[1]"}."\n";
			$name =~ s/$temp[0]\.$temp[1]/$old_genes{"$temp[0].$temp[1]"}/g;
			print OUT3 "$name\n$seq\n";
		}else{
			die "name not found: $temp[0].$temp[1]\n";
		}
	}

}



