#!/bin.bash
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=1:0:0
#$ -l h_vmem=8G
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

#Load modules

#SV bed file...
vcf="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_8_vg/complete_merged_PG2_12_2.all_types.all_types.tags.3.vcf.type.bed";

#Repeat bed file...
repeat_temp_bed="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_4_Annotation/RM_Stuff/RM_200791.MonFeb61712262023/consensi.fa.classified.tmp.repeatmask.RepeatMod_plus_Laura.noLowSoftMask/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta.out.bed";

gene_bed_file="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_4_Annotation/PG2_4_9.4_orthofinder/OrthoFinder/Results_Feb23_1/Orthogroups/PG2_4_4_10.2/LR_SR.PG2_4_4_10.2.results.longest.bed.trimmed";

echo "SV bed";
head $vcf;

echo "repeat bed";
head $repeat_temp_bed;

echo "gene bed";
head $gene_bed_file;

module load bedtools2/2.31.1-python-3.11.7-gcc-12.2.0;

fai="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta.oneline.fasta.nocontam.fa.top23.fai";
cut -f1,2 $fai > $fai.gen
bedtools makewindows -g $fai.gen -w 1000000 > $fai.1Mb

cut -f5 $vcf | sort | uniq -c 

grep "INS$" $vcf > $vcf.INS
grep "DEL$" $vcf > $vcf.DEL
grep "DUP$" $vcf > $vcf.DUP
grep "INV$" $vcf > $vcf.INV

bedtools intersect -a $fai.1Mb -b $gene_bed_file -c > $fai.1Mb.genes
bedtools intersect -a $fai.1Mb -b $vcf -c > $fai.1Mb.SVs
bedtools intersect -a $fai.1Mb -b $repeat_temp_bed -c > $fai.1Mb.repeats
bedtools intersect -a $fai.1Mb -b $vcf.INS -c > $fai.1Mb.SVs.INS
bedtools intersect -a $fai.1Mb -b $vcf.DEL -c > $fai.1Mb.SVs.DEL
bedtools intersect -a $fai.1Mb -b $vcf.INV -c > $fai.1Mb.SVs.INV
bedtools intersect -a $fai.1Mb -b $vcf.DUP -c > $fai.1Mb.SVs.DUP

#So then...
#We want to do frequency of overlaps in 1Mb windows. 

