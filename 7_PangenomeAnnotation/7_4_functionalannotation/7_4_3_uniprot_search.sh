#!/bin.bash
#$ -cwd
#$ -pe smp 6
#$ -l h_rt=240:0:0
#$ -l h_vmem=7G
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

outdir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_26_FunctionalAnnotation";
query="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_26_FunctionalAnnotation/protein_seqs_PG2_20_complete.fasta";
db="$outdir/uniprot_sprot.fasta.db";

cd $outdir;
~/bin/diamond blastp --threads ${NSLOTS} -d $db -q $query -o $outdir/PG2_26_2_diamondUniProt.tsv;


