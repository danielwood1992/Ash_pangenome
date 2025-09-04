#!/bin.bash
#$ -cwd
#$ -pe smp 8
#$ -l h_rt=240:0:0
#$ -l h_vmem=6G
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

~/bin/diamond --help;

outdir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_26_FunctionalAnnotation/nr_database";
db="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_26_FunctionalAnnotation/nr_database/nr.fasta";

~/bin/diamond makedb --threads $NSLOTS --in $db --db $outdir/nr.fasta.db

