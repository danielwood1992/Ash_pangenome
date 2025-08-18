#!/bin.bash
#$ -cwd
#$ -pe smp 8
#$ -l h_rt=240:0:0
#$ -l h_vmem=7G
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

#Set progress tracking
dat=$(date +%Y_%m_%d);

fasta_dir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_4_Annotation/PG2_4_5_Validation/All_for_Orthofinder";

module load miniconda
mamba activate /data/SBCS-BuggsLab-Ash/DanielWood/conda_environments/orthofinder;
export CONDA_ENVS_PATH="/data/SBCS-BuggsLab-Ash/DanielWood/conda_environments/orthofinder/envs";
export CONDA_PKGS_PATH="/data/SBCS-BuggsLab-Ash/DanielWood/conda_environments/orthofinder/pkgs";

orthofinder -f $fasta_dir -t ${NSLOTS};
#Output directoru: 

