#!/bin.bash
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=1:0:0
#$ -l h_vmem=8G
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

#Load modules

#Set progress tracking
vcf="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_8_vg/complete_merged_PG2_12_2.all_types.all_types.tags.3.vcf";
module load bcftools;
bcftools query -f '%CHROM\t%POS\t%ID\t%SVTYPE\t%END\n' $vcf | awk -F '\t' '{ print $1, $2-1, $5-1, $3, $4 }' OFS='\t' > $vcf.type.bed;

repeat_temp_bed="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_4_Annotation/RM_Stuff/RM_200791.MonFeb61712262023/consensi.fa.classified.tmp.repeatmask.RepeatMod_plus_Laura.noLowSoftMask/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta.out";

sed 's/  */ /g' $repeat_temp_bed | sed 's/ /\t/g' | tail -n+4 |  sed 's/^\t//g' | cut -f5,6,7,11 > $repeat_temp_bed.bed;

module load bedtools2;

#ibedtools intersect -a $vcf -b $repeat_temp_bed.bed -wa -wb > $vcf.repeat_overlap
bedtools intersect -a $vcf.type.bed -b $repeat_temp_bed.bed -wao > $vcf.repeat_overlap
truncate -s 0 $vcf.repeat_overlap.report


#With DUP
#37,98337,983#Without DUP


