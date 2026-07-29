#!/bin/bash
#SBATCH -n 1
#SBATCH -t 1:0:0
#SBATCH --mem-per-cpu=7G
#SBATCH -e /gpfs/scratch/mpx545/PG2_AshPanGenome/joblog/%x.%A.%a.err.txt
#SBATCH -o /gpfs/scratch/mpx545/PG2_AshPanGenome/joblog/%x.%A.%a.out.txt

bam_list="/data/SBCS-BuggsLab-Ash/Pangenome_Data/50_sample_ONT_Data/bams_vcf/bams/bam_stats.txt";
truncate -s 0 $bam_list.depths;
while read file;
	do grep "bases mapped (cigar):" $file | cut -f3 | awk '{print $1/840000000}' >> $bam_list.depths;
done < $bam_list;

