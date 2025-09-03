##JOB_NUM##
#KPG0_2
names="/data/home/mpx545/scripts/PG2_RealData/PG2_5_ONTQC/filtered_reads_PG2_5_2.txt_nomandshurica.names";
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

file_list=$1;


ref="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta";

outdir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_20_pangenome_annotation";

file=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1);
echo $file;

#This is the per-individual vcf
file=$outdir/$file.PG2_20_2.vcf;
#This is the subset of those SVs used to build the transformed fasta
kept=$file.PG2_20_2.temp1.txt.PG2_20_2.kept;
#This is a bed file outlining the conversion between the SV sequences and the reference fasta
#It was produced by 7_1_2_mutateref.sh, specifically sub_7_1_3_updatefasta.pl
conversion_bed=$kept.vcf_lines.bed.mod.fasta.conversion_bed
#looks like this:
# Scf9YQZ_1007_HRSCAF_1031 1 23678 1 23678 segment 23677 23677
# Scf9YQZ_1007_HRSCAF_1031 23679 23805 23679 23679 INS 126 0
# Scf9YQZ_1007_HRSCAF_1031 23806 31444 23680 31318 segment 7638 7638
#This gives the scaf, new co-ordinates, ref coordinates, an SV (or segment where it is between SVs), and the length
# So the above example, there is an insertion at 23679 that means position 23680 in BATG-1.0 corresponds
#to position 23806 in the transformed fasta

ls $conversion_bed;

#For the short-read (SR) annotation
#Gets a bed file of the co-ordinates in the gtf
name=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1);
path="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_20_pangenome_annotation/PG2_4_4_2/$name.PG2_4_4_5";
gtf=$path/braker.gtf;
ls $gtf;
awk -F' ' '{print $1"\t"$4"\t"$5"\t"$3"_"$9"_"$10"_"$11"_"$12}' $gtf | sed 's/ /__/g' > $gtf.bed;

#This subfunction takes the gtf (in bed form), and the conversion.bed, and translates the gtf coordinates into reference coordinates
sub1="/data/home/mpx545/scripts/PG2_RealData/PG2_GitHub/7_PangenomeAnnotation/7_3_combineannotations/sub_7_3_4_1_convertgtf.pl";
perl $sub1 $gtf.bed $conversion_bed;
#So we just need the output to also contain the SV num and length, right? 

#The above is repeated for the long-read annotation
#A bit dangerous using the same variable names...
path="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_20_pangenome_annotation/PG2_4_4_2/$name.PG2_4_4_6.lr";
gtf=$path/braker.gtf;
ls $gtf;
awk -F' ' '{print $1"\t"$4"\t"$5"\t"$3"_"$9"_"$10"_"$11"_"$12}' $gtf | sed 's/ /__/g' > $gtf.bed;

sub1="/data/home/mpx545/scripts/PG2_RealData/PG2_GitHub/7_PangenomeAnnotation/7_3_combineannotations/sub_7_3_4_1_convertgtf.pl";
perl $sub1 $gtf.bed $conversion_bed; 
#Outputs for the LR and SR braker.gtf will be braker.gtf.bed.refcoords:
#This will have the gene positions in terms of the reference coordinates, which can be compared between samples

