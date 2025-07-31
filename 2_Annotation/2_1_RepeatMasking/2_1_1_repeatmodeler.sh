#!/bin.bash
#$ -cwd
#$ -pe smp 16
#$ -l h_rt=240:0:0
#$ -l h_vmem=5G
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

#Daniel Wood - July 2023 - Repeatmodeler script

#So this is building a de novo library of putative repeats from the genome sequence alone. 
module load repeatmodeler/2.0.1
#TEST
#file_list=$names;
#SGE_TASK_ID=1;

hap1="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta";
dir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_4_Annotation/PG2_4_1";
#RepeatModeler --help;

BuildDatabase -name $hap1.db $hap1; #Runs very quickly...
cd $dir;
REPCORES=$((NSLOTS/2));
RepeatModeler -database $hap1.db -LTRStruct -pa $REPCORES;


