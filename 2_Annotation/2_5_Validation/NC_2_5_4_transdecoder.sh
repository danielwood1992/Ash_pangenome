#!/bin/bash
#SBATCH -n 1
#SBATCH -t 1:0:0
#SBATCH --mem-per-cpu=6G
#SBATCH -e /gpfs/scratch/mpx545/PG2_AshPanGenome/joblog/%x.%A.%a.err.txt
#SBATCH -o /gpfs/scratch/mpx545/PG2_AshPanGenome/joblog/%x.%A.%a.out.txt

#Set progress tracking
dat=$(date +%Y_%m_%d);

module load miniforge
mamba activate /data/SBCS-BuggsLab-Ash/DanielWood/conda_environments/orfipy;

conda_dir="/data/SBCS-BuggsLab-Ash/DanielWood/conda_environments/orthofinder";

pep="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_4_Annotation/PG2_4_5_Validation/All_for_OrthoFinder_Functional/12870_2020_2656_MOESM6_ESM.fas";
sed 's/ .*//g' $pep > $pep.mod;

#orfipy --help;
orfipy --pep PEP --procs 1 $pep;
#TransDecoder.Predict --version;

#TransDecoder.Predict -t $pep.mod > $pep.longest;

#Output directoru: 


