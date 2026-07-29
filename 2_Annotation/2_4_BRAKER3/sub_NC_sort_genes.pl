use POSIX;
use strict;

my $overlaps = $ARGV[0];
my $protein_list = $ARGV[1];
my $gtf = $ARGV[2];
my $bed = $ARGV[3];

my ($line, @temp, %hash2, %hash);

#1) From each of the pairs, find which protein is longest...
open(IN, "<$overlaps");
while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	$line =~ s/;//g;
	$line =~ s/"//g;
	@temp = split/ /, $line;
	$hash{"$temp[1]$temp[0]"} = "";
	$hash{"$temp[3]$temp[2]"} = "";
	$hash2{"$temp[1]$temp[0] $temp[3]$temp[2]"} = "";
	print "$temp[1]$temp[0] $temp[3]$temp[2]\n";
}

my ($name, $seq, $file);

open(IN, "<$protein_list");
#For each gene, get the longest protein. The one with the shortest protein will be removed.
while(!eof(IN)){
	$file = readline *IN;
	chomp $file;
	open(IN2, "<$file");
	while(!eof(IN2)){
		$name = readline *IN2;
		chomp $name;
		$seq = readline *IN2;
		chomp $seq;
		if ($name =~ m/^>/){
		}else{
			die "Incorrectly formatted fasta: $file";
		}

		$name =~ s/>//g;
		$name =~ s/\.t.*//g;
		if (exists $hash{$name}){
			if (length($seq) > $hash{$name}){
				$hash{$name} = length($seq);
				#print $hash{$name}."\n";
			}
		}

	}
}

#3 Identify which of the two genes in each pair to eliminate...
my ($item);
my (%to_remove);

foreach $item (keys %hash2){
	@temp = split/ /, $item;
	if (exists $hash{$temp[0]} && exists $hash{$temp[1]}){
	}else{
		die "Couldn't find a protein sequence for $temp[0] or $temp[1]\n";
	}
	if ($hash{$temp[0]} > $hash{$temp[1]}){
		$to_remove{$temp[0]} = "";
	}else{
		$to_remove{$temp[1]} = "";
	}

}

#4 Go through the gtf and remove these troublesome genes...
my $total = scalar(keys %to_remove);
my $count = 0;

open(IN, "<$gtf");
open(OUT, ">$gtf.trimmed");
while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	@temp = split/\t/, $line;
	if ($temp[8] =~ m/^transcript_id/){
		$temp[8] =~ s/.*gene_id "//g;
		$temp[8] =~ s/".*//g;
		#print "transcript: $temp[8]\n";
	}elsif($temp[8] =~ m/^g/){
		$temp[8] =~ s/\..*//g;
		#print "gene: $temp[8]\n";
	}else{
		die "GTF in weird format";
	}
	if (exists $to_remove{"$temp[9]$temp[8]"}){
		$to_remove{"$temp[9]$temp[8]"}++;
	}else{
		print OUT $line."\n";
	}
}
foreach $item (keys %to_remove){
	if (%to_remove{$item} > 0){
		$count++;
	}
}
print "Total to find: $total, count found: $count\n";

#Goes through the bed file and does the same...

my $total = scalar(keys %to_remove);
my $count = 0;
my %found;

open(IN, "<$bed");
open(OUT, ">$bed.trimmed");
while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	@temp = split/\t/, $line;
	$temp[6] =~ s/\..*//g;
	if (exists $to_remove{"$temp[7]$temp[6]"}){
		$found{"$temp[7]$temp[6]"} = "";
	}else{
		print OUT $line."\n";
	}
}
my $count = scalar(keys %found);
print "Total to find in bed: $total, count found; $count\n";

