##JOB_NUM##
#KPG0_2
names="/data/home/mpx545/scripts/PG2_RealData/PG2_5_ONTQC/filtered_reads_PG2_5_2.txt_nomandshurica.names";
#head -n 1 $names > $names.tst;
#names=$names.tst; 
ARRAY_NUM=$(cat $names | wc -l);
ARRAY_NUM="$ARRAY_NUM $names";
echo $ARRAY_NUM;

##ARRAY_BIT##

#!/bin.bash
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=1:0:0
#$ -l h_vmem=8G
#$ -t ?
#$ -tc 100
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

#Load modules

#Set progress tracking
dat=$(date +%Y_%m_%d);

#REAL

file_list=$1;

#TEST
#file_list=$names;
#SGE_TASK_ID=1;

ref="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta";

outdir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_20_pangenome_annotation";

file=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1);
file=$outdir/$file.PG2_20_2.vcf;


#So...figuring out how to write this
#Q1: Do the alleles overlap each other? You would hope not, otherwise they would surely be merged...
module load bcftools/1.16;
module load bedtools/2.28.0;

#So step 1: Figure out which actual alleles/sequences to use...
#Some SVs overlap with each other. This may be due to a) the different SV callers predicting slightly different, overlapping sites for the SV, or b) the SVs being heterozygous within that indiviudal.
#Here I am going to priortise keeping insertions - deletions should be more accurately annotated from the existing reference. 
#Obviously this could mess up the actual sequence...but these things aren't phased anyway, so there's not really all that much point worrying about it.
#Insertions shouldn't overlap with each other - if the breakpoints are within 200bp they should have been merged.
#Also report which SVs are being removed, and check it's not too many etc.

#Identify which SVs overlap?
bcftools query -f "%CHROM\t%POS\t%END\t%SVTYPE\t%SVLEN\n" $file > $file.PG2_20_2.temp1.txt;
sed -i "s/\t-/\t/g" $file.PG2_20_2.temp1.txt; #Should just be making all the lengths positive, even for deletions
bedtools intersect -a $file.PG2_20_2.temp1.txt -b $file.PG2_20_2.temp1.txt -wa -wb > $file.PG2_20_2.temp2.txt;
#Output of this will be:
#Scaf\tStart\tEnd\tType\tLength\tScaf\tStart\tType\tLength for overlapping SVs

#Subfunction - this goes through and keeps nonoverlapping SVs: insertions preferentially, otherwise whichever is longer 
sub1="/data/home/mpx545/scripts/PG2_RealData/PG2_GitHub/7_PangenomeAnnotation/7_1_reftransform/sub_7_1_2_1_getnooverlaps.pl";
perl $sub1 $file.PG2_20_2.temp2.txt $file.PG2_20_2.temp1.txt;
kept=$file.PG2_20_2.temp1.txt.PG2_20_2.kept;


#Sanity check - these two numbers should be the same (i.e. no overlaps in final file)
wc -l $kept; #So the kept ones shouldn't have any overlaps, so should only overlap with themselves
bedtools intersect -a $kept -b $kept -wa -wb | wc -l;
bedtools intersect -a $kept -b $file -wb > $file.PG2_20_2.temp3;

#So then we need to find the vcf entries that correspond to these...
sub2="/data/home/mpx545/scripts/PG2_RealData/PG2_GitHub/7_PangenomeAnnotation/7_1_reftransform/sub_7_1_2_2_getseqs.pl";
perl $sub2 $kept $file > $kept.vcf_lines;

#Get the equivalent of a bed file out of this, for the SVs you want to use to transform the fasta....
bcftools query -f "%CHROM\t%POS\t%END\t%SVTYPE\t%SVLEN\\t%REF\t%ALT\n" $kept.vcf_lines > $kept.vcf_lines.bed;
#So this has the form Scaf\tStart\tEnd\tLength\tRef\tAlt
fasta="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta.oneline.fasta";

#sub3 updates the fasta with this information: replacing ref sequences with alt sequneces at the appropriate points
sub3="/data/home/mpx545/scripts/PG2_RealData/PG2_GitHub/7_PangenomeAnnotation/7_1_reftransform/sub_7_1_2_3_updatefasta.pl";
perl $sub3 $kept.vcf_lines.bed $fasta;
#Outputs: $kept.vcf_lines.bed.mod.fasta 

