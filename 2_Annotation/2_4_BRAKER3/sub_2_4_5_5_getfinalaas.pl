use POSIX;
use strict;


my $aa_list = $ARGV[0];
my $final_gtf = $ARGV[1];

#To do: read the gtf file, get the gene sequences, identify which aa file these should come from.
#Then for each gtf file, go through  the AA file and if it matches a gene we need, put this into the final file
#

open(IN, "<$final_gtf");
my (@temp, @temp2, %hash, $line);
#Gets a list of amino acid sequences required, per run, per gene name
while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	@temp = split/\t/, $line;
	@temp2 = split/\./, $temp[-2];
#	print "$temp2[0] $temp2[1] $temp[-3]\n";
	$hash{$temp2[0]}{$temp2[1]}{$temp[-3]} = "";  #So a hash with $hash{LR}{run9}{$gene_name};
}

#Now to read through the aa files and get the outputs;
my (@temp, @temp2, @temp3, @temp4, $type, $run, $name, $seq, $line);

open(OUT, ">$final_gtf.aa.fasta");

open(IN, "<$aa_list");
while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	#Splits the filename to get the relevant run type (LR/SR) and number (1...10).
	@temp = split/\//, $line;
	@temp2 = split/\./, $temp[-1];
	$type = $temp2[2];
	$run = "run$temp2[1]";
	print $line."\n";
	open(IN2, "<$line");
	while(!eof(IN2)){
		#These should be non-interleaved: will throw an error if that's not the case
		$name = readline *IN2;
		$seq = readline *IN2;

		if ($name =~ m/^>/){}else{die "wrong fasta file format\n";}

		chomp $name;
		chomp $seq;

		#Gets the gene name - if it's what's needed, prints out the name and sequence to a final file...
		@temp3 = split/g/, $name;
		if (exists ($hash{$type}{$run}{"g$temp3[1]"})){
			#Note: before you worry, the gene names here each have the associated run information ahead of the gene name.
			#This was done by 2_4_3_LRSRaas.sh
			print OUT "$name\n$seq\n";
		} 
	}
}



