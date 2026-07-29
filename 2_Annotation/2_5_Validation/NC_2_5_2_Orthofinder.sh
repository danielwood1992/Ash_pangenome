#!/bin/bash
#SBATCH -n 10
#SBATCH -t 240:0:0
#SBATCH --mem-per-cpu=6G
#SBATCH -e /gpfs/scratch/mpx545/PG2_AshPanGenome/joblog/%x.%A.%a.err.txt
#SBATCH -o /gpfs/scratch/mpx545/PG2_AshPanGenome/joblog/%x.%A.%a.out.txt

#Set progress tracking
dat=$(date +%Y_%m_%d);

#fasta_dir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_4_Annotation/PG2_4_5_Validation/All_for_Orthofinder_new";
fasta_dir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_4_Annotation/PG2_4_5_Validation/All_for_OrthoFinder_Functional";


module load miniforge
mamba activate /data/SBCS-BuggsLab-Ash/DanielWood/conda_environments/orthofinder;
#export CONDA_ENVS_PATH="/data/SBCS-BuggsLab-Ash/DanielWood/conda_environments/orthofinder/envs";
#export CONDA_PKGS_PATH="/data/SBCS-BuggsLab-Ash/DanielWood/conda_environments/orthofinder/pkgs";

conda_dir="/data/SBCS-BuggsLab-Ash/DanielWood/conda_environments/orthofinder";

$conda_dir/bin/python $conda_dir/bin/orthofinder -f $fasta_dir -t ${SLURM_NTASKS};

#Output directoru: 

