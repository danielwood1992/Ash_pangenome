use POSIX;
use strict;

#Using the results of PG2_20_9_PanGenome_Results.R: identify the genes that are a) included vs filtered, and b) invariant vs. pangenome...

#my $filtered_list="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_26_FunctionalAnnotation/PG2_20_9_results.txt.F1.filtered";
#my $excluded_list="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_26_FunctionalAnnotation/PG2_20_9_results.txt.excluded";
#my $pangenome_fasta = "/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_26_FunctionalAnnotation/protein_seqs_PG2_20_complete.fasta";

my $filtered_list = $ARGV[0];
my $pangenome_fasta = $ARGV[1];
my $excluded_list = $ARGV[2];

my ($name, $seq, @temp, %hash);
open(IN, "<$pangenome_fasta");
#Names of these look like this: 
# >LR.run9g1345.t1.OG0000000.bed.0.txt

while(!eof(IN)){
	$name = readline *IN;
	chomp $name;
	$seq = readline *IN;
	chomp $seq;
	if ($name =~ m/^>/){
	}else{
		die
	}
	@temp = split/\./, $name;
	#The hash shiuld be set up as hash{OG00000.bed.0.txt} etc.
	if (exists ($hash{"$temp[-4].$temp[-3].$temp[-2].$temp[-1]"})){
		die "These names should be unique\n";
	}
#	print "$temp[-4].$temp[-3].$temp[-2].$temp[-1]\n";
	$name =~ s/>//g;
	$hash{"$temp[-4].$temp[-3].$temp[-2].$temp[-1]"}[0] = $name; #[0] - the gene name
	$hash{"$temp[-4].$temp[-3].$temp[-2].$temp[-1]"}[1] = ""; #[1] - NI = filtered out, I = included...
	$hash{"$temp[-4].$temp[-3].$temp[-2].$temp[-1]"}[2] = ""; #[2] - NV = not variable, V = variable


}
my ($line, @temp0, @temp1, @temp2, $name);
open(IN, "<$filtered_list");
#Format for this and excluded list looks like this: 
#/path/2/file/OG0009785.bed.1.txt.SVs    AR      42      9       10      6       36      4       5       Scf9YQZ_4_HRSCAF_5;26414590;26414590;INS;821    0.421052631578947

while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	@temp0 = split/\t/, $line;
	@temp1 = split/\//,  $temp0[0];
	#So $temp1[-1] should be OG0009785.bed.1.txt.SVs 
	@temp2 = split/\./, $temp1[-1];
	
	
	$name = "$temp2[-5].$temp2[-4].$temp2[-3].$temp2[-2]";
	if (exists ($hash{"$name"})){

		#Sets the gene properties
		$hash{$name}[1] = "I"; #Sets as included (i.e. passes the filtering)
		$hash{$name}[2] = "NV"; #Sets as not variable (unless it's set as variable below)
		if ($temp0[1] ne "AR"){
			print "woof\n";
			$hash{$name}[2] = "V";
		}
	}
}

open(IN, "<$excluded_list");
while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	@temp0 = split/\t/, $line;
	@temp1 = split/\//,  $temp0[0];
	@temp2 = split/\./, $temp1[-1];

	$name = "$temp2[-5].$temp2[-4].$temp2[-3].$temp2[-2]";
	if (exists ($hash{"$name"})){
		#So if it's in here, let's say it's "included" vs. excluded...
		$hash{$name}[1] = "NI";
#		if $(
	}
}

#Outpouts files for included genes, excluded genes, and for the included genes whether they are dispensible (V) or invariant (NV)
open(OUT_I, ">$pangenome_fasta.list.I");
open(OUT_NI, ">$pangenome_fasta.list.NI");
open(OUT_V, ">$pangenome_fasta.list.V");
open(OUT_NV, ">$pangenome_fasta.list.NV");
my ($item);

foreach $item (keys (%hash)){
	if ($hash{$item}[1] eq "NI"){
		print OUT_NI $hash{$item}[0]."\n"; 
	}
	if ($hash{$item}[1] eq "I"){
		print OUT_I $hash{$item}[0]."\n";
		if ($hash{$item}[2] eq "V"){
			print OUT_V $hash{$item}[0]."\n";	
		}else{	
			print OUT_NV $hash{$item}[0]."\n";	
		}
	}
}

#Gets files that are included+excluded, variable+invariant, variable+notincluded
`cat $pangenome_fasta.list.I $pangenome_fasta.list.NI > $pangenome_fasta.list.I_NI`;
`cat $pangenome_fasta.list.V $pangenome_fasta.list.NV > $pangenome_fasta.list.V_NV`;
`cat $pangenome_fasta.list.V $pangenome_fasta.list.NI > $pangenome_fasta.list.V_NI`;
