use POSIX;
use strict;

my $big_bed = $ARGV[0];
#This is the combined bed file, with one entry per non-overlapping ortholog
my $gtf_list = $ARGV[1]; #This is the list of relevant gtfs

my ($line, @temp, $gene, $run, %hash, $gtf_run, $id);

open(IN, "<$big_bed");
while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	@temp = split/\t/, $line;
	$gene = $temp[6];
	$gene =~ s/\..*//g;
	$run = $temp[7];
	$hash{$run}{$gene} = ""; #So for each run, get the list of genes...
				 #Then I guess we just need to find the genes in each gtf file...
}
my ($line2, @temp2);
#Opens out the big list of gtfs...
open(IN, "<$gtf_list");
open(OUT, ">$big_bed.temp");
while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	@temp = split/\t/, $line;
	#Gets the name for each gtf runn
	$gtf_run = "$temp[0].run$temp[1]";
	print $gtf_run."\n";
	#Opens the gtf file
	open(IN2, "<$temp[2]");
	while(!eof(IN2)){
		$line2 = readline *IN2;
		chomp $line2;
		@temp2 = split/\t/, $line2;
		#Regex to extract the relevant gene name that may match
		$id = $temp2[-1];
		$id =~ s/^.*?"//g;
		$id =~ s/\..*//g;
#		if ($id !~ m/\.t/){
#			$id = "$id.t1";
#		}

		#If for this run, this gene is the representative sequence for one of the orthologs, print it out
		if (exists ($hash{$gtf_run}{$id})){
#			print "exists $id $line2\n";
			print OUT "$line2\t$gtf_run\n";
		}else{
#			print "nope $id $line2\n";
		}
	}
}
#Sorts by chromosome, then genomic positions, to get a final gtf
`sort -k1,1 -k4,4n -k5,5n $big_bed.temp > $big_bed.final.gtf`;
