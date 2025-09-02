#So what we will do instead...
#1) Read all the positions etc. and convert into a bed file
#2) Retrieve all these sequences from the genome
#3) Remove those tha toverlap an N
vcf=$1;
genome=$2;
module load bedtools; #version unspecified

#So this is getting the scaff, the N-1th position prior to the start, and what is referred to as the END flag. Puts this in a bed file. 
#Basically, this is a bed file of the positions of the referecnce allele, according to the vcf
grep -v '#' $vcf | awk '{print $1, ($2-1), $8}' | sed 's/SUPP.*;END=//g' | sed 's/;.*//g' | sed 's/ /\t/g' > $vcf.bed;

#Then retrieves the sequences for these regions using bedtools
bedtools getfasta -fi $genome -bed $vcf.bed -tab > $vcf.bed.tab
#output is Scf:start-end\tsequence

#Note: in the workflow I actually ran (as of 02/09/25), the below subfunction was not in this script. But the main script requires the outfile for it, so I must have just ran it manually. 
sub="/data/home/mpx545/scripts/PG2_RealData/PG2_GitHub/4_SVCalling/4_5_Fix/sub_4_5_1_2.1_noN.pl";
perl $sub $vcf.bed.tab;
#This just goes through and removes the sequences that contain an "N" - i.e. SVs that overlap an N
