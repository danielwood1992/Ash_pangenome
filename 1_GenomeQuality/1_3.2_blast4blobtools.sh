#!/bin.bash
#$ -cwd
#$ -pe smp 16
#$ -l h_rt=240:0:0
#$ -l h_vmem=7G


fasta_name="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta";
#fasta_name="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap2-mb-hirise-c1e0t__01-11-2023__hic_output.fasta";

nt="/data/PublicDataSets/shared_dbs/nt/2023-02-21";
module load blast+/2.11.0;
export BLASTDB=$nt;
blastn -db nt -query $fasta_name -outfmt "6 qseqid staxids bitscore std" -max_target_seqs 10  -max_hsps 1 -evalue 1e-25 -num_threads 16 -out $fasta_name.2023.blast.out


