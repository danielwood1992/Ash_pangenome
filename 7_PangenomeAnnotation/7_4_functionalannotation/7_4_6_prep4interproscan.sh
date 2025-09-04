#!/bin.bash
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=240:0:0
#$ -l h_vmem=7G
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

#~/bin/diamond blastp;
file="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_26_FunctionalAnnotation/protein_seqs_PG2_20_complete.fasta";

sub="";
perl /data/home/mpx545/scripts/PG2_RealData/PG2_26_FunctionalAnnotation/split_rmstar.pl $file

ls $file.*fasta >> $file.list;
