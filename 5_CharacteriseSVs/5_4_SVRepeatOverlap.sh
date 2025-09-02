#!/bin.bash
#$ -cwd
#$ -pe smp 4
#$ -l h_rt=1:0:0
#$ -l h_vmem=8G
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

#Load modules

#Set progress tracking
vcf="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_8_vg/complete_merged_PG2_12_2.all_types.all_types.tags.3.vcf";
module load bcftools;
bcftools query -f '%CHROM\t%POS\t%SVTYPE\t%END\n' $vcf | awk -F '\t' '{ print $1, $2-1, $4-1, $3 }' OFS='\t' > $vcf.type.bed;

repeat_temp_bed="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_4_Annotation/RM_Stuff/RM_200791.MonFeb61712262023/consensi.fa.classified.tmp.repeatmask.RepeatMod_plus_Laura.noLowSoftMask/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta.out";

sed 's/  */ /g' $repeat_temp_bed | sed 's/ /\t/g' | tail -n+4 |  sed 's/^\t//g' | cut -f5,6,7,11 > $repeat_temp_bed.bed;

module load bedtools;

#ibedtools intersect -a $vcf -b $repeat_temp_bed.bed -wa -wb > $vcf.repeat_overlap
bedtools intersect -a $vcf.type.bed -b $repeat_temp_bed.bed -wa -wb > $vcf.repeat_overlap
truncate -s 0 $vcf.repeat_overlap.report
#With DUP
#Without DUP
echo -e "total number of SVs" >> $vcf.repeat_overlap.report
cut -f4 $vcf.type.bed | sed 's/\/.*//g' | sort | uniq -c | sed 's/^[[:space:]]*//' | awk '{count[$2]=$1; total+=$1} END {for (key in count) {printf "%s %d %.2f%%\n", key, count[key], (count[key]/total)*100}}' >> $vcf.repeat_overlap.report;

echo -e "total number of repeats" >> $vcf.repeat_overlap.report
cut -f4 $repeat_temp_bed.bed | sed 's/\/.*//g' | sort | uniq -c | sed 's/^[[:space:]]*//' | awk '{count[$2]=$1; total+=$1} END {for (key in count) {printf "%s %d %.2f%%\n", key, count[key], (count[key]/total)*100}}' >> $vcf.repeat_overlap.report;


n_variants=$(cut -f1-3 $vcf.repeat_overlap | sort | uniq -c | wc -l);
n_svs=$(grep -v '#' $vcf | wc -l)
echo -e "$n_variants SVs out of $n_svs overlap with a repeat" >> $vcf.repeat_overlap.report;
echo -e "\nby variant type\n" >> $vcf.repeat_overlap.report;
cut -f1-4 $vcf.repeat_overlap | sort | uniq | cut -f4 | sort | uniq -c | sed 's/^[[:space:]]*//' | awk '{count[$2]=$1; total+=$1} END {for (key in count) {printf "%s %d %.2f%%\n", key, count[key], (count[key]/total)*100}}' >> $vcf.repeat_overlap.report;
echo -e "\nby repeat type - overall\n" >> $vcf.repeat_overlap.report;
cut -f5-8 $vcf.repeat_overlap | sed 's/\/.*//g' | sort | uniq | cut -f4 | sort | uniq -c | sed 's/^[[:space:]]*//' | awk '{count[$2]=$1; total+=$1} END {for (key in count) {printf "%s %d %.2f%%\n", key, count[key], (count[key]/total)*100}}'   >> $vcf.repeat_overlap.report;

echo -e "\nby repeat type - DEL only\n" >> $vcf.repeat_overlap.report;
grep 'DEL' $vcf.repeat_overlap | cut -f5-8 | sed 's/\/.*//g' | sort | uniq | cut -f4 | sort | uniq -c | sed 's/^[[:space:]]*//' | awk '{count[$2]=$1; total+=$1} END {for (key in count) {printf "%s %d %.2f%%\n", key, count[key], (count[key]/total)*100}}'  >> $vcf.repeat_overlap.report;

echo -e "\nby repeat type - INS only\n" >> $vcf.repeat_overlap.report;
grep 'INS' $vcf.repeat_overlap | cut -f5-8 | sed 's/\/.*//g' | sort | uniq | cut -f4 | sort | uniq -c | sed 's/^[[:space:]]*//' | awk '{count[$2]=$1; total+=$1} END {for (key in count) {printf "%s %d %.2f%%\n", key, count[key], (count[key]/total)*100}}'  >> $vcf.repeat_overlap.report;

echo -e "\nby repeat type - INV only\n" >> $vcf.repeat_overlap.report;
grep 'INV' $vcf.repeat_overlap | cut -f5-8 | sed 's/\/.*//g' | sort | uniq | cut -f4 | sort | uniq -c | sed 's/^[[:space:]]*//' | awk '{count[$2]=$1; total+=$1} END {for (key in count) {printf "%s %d %.2f%%\n", key, count[key], (count[key]/total)*100}}' >> $vcf.repeat_overlap.report;

echo -e "\nby repeat type - DUP only\n" >> $vcf.repeat_overlap.report;
grep 'DUP' $vcf.repeat_overlap | cut -f5-8 | sed 's/\/.*//g' | sort | uniq | cut -f4 | sort | uniq -c | sed 's/^[[:space:]]*//' | awk '{count[$2]=$1; total+=$1} END {for (key in count) {printf "%s %d %.2f%%\n", key, count[key], (count[key]/total)*100}}' >> $vcf.repeat_overlap.report;

echo -e "\hby repeat type - detailed\n" >> $vcf.repeat_overlap.report;
cut -f5-8 $vcf.repeat_overlap | sort | uniq | cut -f4 | sort | uniq -c | sed 's/^[[:space:]]*//' | awk '{count[$2]=$1; total+=$1} END {for (key in count) {printf "%s %d %.2f%%\n", key, count[key], (count[key]/total)*100}}' >> $vcf.repeat_overlap.report;

