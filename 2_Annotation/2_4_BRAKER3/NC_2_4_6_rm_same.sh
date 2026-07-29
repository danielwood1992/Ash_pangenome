#So I would like to find genes that are i) on the same strand, and ii) have a CDS that overlaps by >50% with another gene.
#I will take these genes, and the one with the total longest CDS will be considered.
gtf="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_4_Annotation/PG2_4_9.4_orthofinder/OrthoFinder/Results_Feb23_1/Orthogroups/PG2_4_4_10.2/LR_SR.PG2_4_4_10.2.results.longest.bed.final.gtf";

bed="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_4_Annotation/PG2_4_9.4_orthofinder/OrthoFinder/Results_Feb23_1/Orthogroups/PG2_4_4_10.2/LR_SR.PG2_4_4_10.2.results.longest.bed";

#So we want the CDS

awk -F'\t' 'BEGIN{OFS="\t"} $3=="CDS" && $7=="+" {print $1, $4, $5, $7, $9, $10}' $gtf | sed 's/ /\t/g' >  $gtf.plusCDS
awk -F'\t' 'BEGIN{OFS="\t"} $3=="CDS" && $7=="-" {print $1, $4, $5, $7, $9, $10}' $gtf|  sed 's/ /\t/g'  > $gtf.minusCDS

module load bedtools2/2.31.1-python-3.11.7-gcc-12.2.0
#So we want to get things that overlap. And I guess we want to ignore i) comparisons within the same gene?
#This gives the CDS where there is an intesection with a CDS from a different run of >50%
bedtools intersect -a $gtf.plusCDS -b $gtf.plusCDS -f 0.5 -wa -wb | awk '!($8 == $17 && $9 == $18)' > $gtf.plusCDS.overlaps;
bedtools intersect -a $gtf.minusCDS -b $gtf.minusCDS -f 0.5 -wa -wb | awk '!($8 == $17 && $9 == $18)' > $gtf.minusCDS.overlaps;
#So we then want to know which gene pairs are responsible...

cut -f8,9,17,18 $gtf.plusCDS.overlaps | awk '{if ($1 < $3 || ($1 == $3 && $2 < $4)) {
    a1=$1; a2=$2; b1=$3; b2=$4
  } else {
    a1=$3; a2=$4; b1=$1; b2=$2
  }
  print a1,a2,b1,b2}' | sort -u > $gtf.plusCDS.overlaps.pairs;


cut -f8,9,17,18 $gtf.minusCDS.overlaps | awk '{if ($1 < $3 || ($1 == $3 && $2 < $4)) {
    a1=$1; a2=$2; b1=$3; b2=$4
  } else {
    a1=$3; a2=$4; b1=$1; b2=$2
  }
  print a1,a2,b1,b2}' | sort -u > $gtf.minusCDS.overlaps.pairs;

cat $gtf.plusCDS.overlaps.pairs $gtf.minusCDS.overlaps.pairs > $gtf.overlapping_pairs.txt
proteins="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_4_Annotation/PG2_4_9.4_orthofinder/run_list.txt";

sub="/data/home/mpx545/scripts/PG2_RealData/PG2_GitHub/2_Annotation/2_4_BRAKER3/sub_NC_sort_genes.pl";
perl $sub $gtf.overlapping_pairs.txt $proteins $gtf $bed
