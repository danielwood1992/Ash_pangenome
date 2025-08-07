use POSIX;
use strict;

my $file = $ARGV[0];

open(IN, "<$file");

my (%hash, $line, @temp, $first, $prev, $location, $to_print, $item, $temp_item);
my $i = 0;
my $first = "T";
my %hash;
#So if there are multiple genes assigned to one location, take the longest

while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	@temp = split/\t/, $line;
	$location = "$temp[0] $temp[1] $temp[2]";
	if ($first eq "T"){
		$first = "F";
		$prev = $location;
		$to_print = $line;
		$hash{$location}{$temp[7]}[0] = $temp[5]-$temp[4];
		$hash{$location}{$temp[7]}[1] = $line;		

	}elsif ($location eq $prev){
		if (($temp[5]-$temp[4]) > $hash{$location}{$temp[7]}[0]){
			$hash{$location}{$temp[7]}[0] = $temp[5]-$temp[4];
			$hash{$location}{$temp[7]}[1] = $line;		
		}
	}else{
#		print "1\n";
#		foreach $temp_item (keys %hash){
#			print "$i $temp_item $hash{$temp_item}[0] $hash{$temp_item}[1]\n";
#		}	

		open(OUT, ">$file.$i.txt");
		foreach $item (keys %{$hash{$prev}}){
			print OUT $hash{$prev}{$item}[1]."\n";
		}
		close OUT;
		$prev = $location;		
#		my %hash = ();
		

		#So it seems to be getting deleted here, and yet somehow being resurrected elsewhere?
		
		$hash{$location}{$temp[7]}[0] = $temp[5]-$temp[4];
		$hash{$location}{$temp[7]}[1] = $line;		
		print $hash{$location}{$temp[7]}[1]."\n";
		print "3\n";

	
		$i++;
	}
}
		open(OUT, ">$file.$i.txt");
		foreach $item (keys %{$hash{$prev}}){
			print OUT $hash{$location}{$item}[1]."\n";
		}


