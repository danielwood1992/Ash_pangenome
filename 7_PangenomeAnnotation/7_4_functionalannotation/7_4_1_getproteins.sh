#!/bin.bash
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=1:0:0
#$ -l h_vmem=6G
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

#Launches subfunction
sub="/data/home/mpx545/scripts/PG2_RealData/PG2_GitHub/7_PangenomeAnnotation/7_4_functionalannotation/sub_7_4_1_1_getproteins.pl";
perl $sub;
