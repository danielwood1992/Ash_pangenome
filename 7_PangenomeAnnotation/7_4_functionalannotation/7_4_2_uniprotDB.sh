#!/bin.bash
#$ -cwd
#$ -pe smp 4
#$ -l h_rt=24:0:0
#$ -l h_vmem=6G
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

#Makes diamond database from swissprot/uniprot

~/bin/diamond --help;

outdir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_26_FunctionalAnnotation/";
db="/data/PublicDataSets/shared_dbs/uniprot/swissprot/2024-07-24/uniprot_sprot.fasta";

~/bin/diamond makedb --threads $NSLOTS --in $db --db $outdir/uniprot_sprot.fasta.db



