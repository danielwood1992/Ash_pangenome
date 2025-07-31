#!/bin.bash
#$ -cwd
#$ -pe smp 5
#$ -l h_rt=1:0:0
#$ -l h_vmem=8G
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

dir="/data/scratch/mpx545/PG2_AshPanGenome";
hap="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta";

module load miniconda;
mamba activate /data/home/mpx545/conda_environments/star;
mkdir $hap.starindex;
STAR --runMode genomeGenerate --genomeDir $hap.starindex --genomeFastaFiles $hap --genomeSAindexNbases 13 --runThreadN 5;
