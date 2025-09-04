#!/bin.bash
#$ -cwd
#$ -pe smp 4
#$ -l h_rt=240:0:0
#$ -l h_vmem=7G
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

#~/bin/diamond blastp;

outdir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_26_FunctionalAnnotation/nr_database";
#db="/data/PublicDataSets/shared_dbs/uniprot/swissprot/2024-07-24/uniprot_sprot.fasta";
query="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_26_FunctionalAnnotation/protein_seqs_PG2_20_complete.fasta";
db="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_26_FunctionalAnnotation/nr_database/nr.fasta.db.dmnd";

cd $outdir;
#blastdbcmd -entry all -db nr -out nr.fsa
~/bin/diamond blastp --threads ${NSLOTS} -d $db -q $query -o $outdir/PG2_26_2_diamondNR.tsv;

#~/bin/diamond makedb --threads $NSLOTS --in $db --db $outdir/uniprot_sprot.fasta.db





