#!/bin.bash
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=240:0:0
#$ -l h_vmem=6G
#$ -e /data/home/mpx545/scripts/PG2_RealData/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/home/mpx545/scripts/PG2_RealData/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

cd $dir;


wget -r --cut-dirs=2 -np -nH -R "index.html*" https://cgr.liv.ac.uk/illum/SSP203991_2259888d661f74a1/Raw/


/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/CGR_RNASeq
