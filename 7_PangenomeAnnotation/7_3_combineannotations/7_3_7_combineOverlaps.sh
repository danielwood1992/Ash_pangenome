#!/bin/bash
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=1:0:0
#$ -l h_vmem=8G
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

dir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_20_pangenome_annotation/PG2_4_4_2/PG2_20_5_toOrthofind_2/OrthoFinder/Results_Jun24/Orthogroups/PG2_20_5";

#Combnes outputs into one file
truncate -s 0 $dir/PG2_20_9_results.txt;
for file in $dir/*SVsGenes;
	do cat $file >> $dir/PG2_20_9_results.txt;
done;

#Calculates F1 scores based on gene presence/absence
sub="/data/home/mpx545/scripts/PG2_RealData/PG2_GitHub/7_PangenomeAnnotation/7_3_combineannotations/sub_7_3_7_1_F1.pl";
perl $sub $dir/PG2_20_9_results.txt


