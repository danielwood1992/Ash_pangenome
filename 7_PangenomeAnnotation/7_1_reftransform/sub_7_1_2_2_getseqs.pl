use strict;
use POSIX;

# Get patterns file and VCF file from command-line arguments
my $patterns_file = $ARGV[0];
#This has pattern Scaf\tStart\tEnd\tSVType\tLength
my $vcf = $ARGV[1];
#This is the vcg
my ($line, @temp, %hash, $scaff, $start, $end, $type, $length);

# Read patterns file and store patterns in a hash
open(IN, "<$patterns_file");
while (!eof(IN)) {
    $line = readline *IN;
    chomp $line;
    @temp = split /\t/, $line;

    # Store the pattern in a hash for efficient lookup
    $hash{"$temp[0]\t$temp[1]\t$temp[2]\t$temp[3]\t$temp[4]"} = 1;
}
close(IN);

# Read VCF file and filter lines based on conditions
open(IN, "<$vcf");
while (!eof(IN)) {
    $line = readline *IN;
    chomp $line;

    if ($line =~ m/^#/) {
	print $line."\n";
        # Skip comment lines in the VCF file
    } else {
        @temp = split /\t/, $line;
        $scaff = $temp[0];
        $start = $temp[1];

        # Extract END value from the VCF line
        $end = $line;
        $end =~ s/.*;END=//;
        $end =~ s/;.*//;

        # Extract SVTYPE value from the VCF line
        $type = $line;
        $type =~ s/.*;SVTYPE=//;
        $type =~ s/;.*//;

        # Extract SVLEN value from the VCF line
        $length = $line;
        $length =~ s/.*SVLEN=//;
        $length =~ s/;.*//;
        $length =~ s/-//g;

        # Print the filtered output
        if (exists ($hash{"$scaff\t$start\t$end\t$type\t$length"})){
		print $line."\n"; #Keep the vcf sequences
	}
    }
}
close(IN);
