#!/bin/bash
#SBATCH -n 4
#SBATCH -t 1:0:0
#SBATCH --mem-per-cpu=7G
#SBATCH -e /gpfs/scratch/mpx545/PG2_AshPanGenome/joblog/%x.%A.%a.err.txt
#SBATCH -o /gpfs/scratch/mpx545/PG2_AshPanGenome/joblog/%x.%A.%a.out.txt

module load miniforge;

conda_dir="/data/home/mpx545/conda_environments/busco";
mamba activate /data/home/mpx545/conda_environments/busco
export CONDA_ENVS_PATH=/data/home/mpx545/conda_environments/busco/envs
export CONDA_PKGS_PATH=/data/home/mpx545/conda_environments/busco/pkgs
#busco --help;


database="/data/home/mpx545/eudicots_odb10";

outdir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_4_Annotation/PG2_4_5_Validation/PG2_4_4_2.1_BUSCO_proteins_update";
rm -r $outdir;
mkdir $outdir;
cd $outdir;

#module load hmmer/3.1b2;
module load hmmer/3.4-openmpi-5.0.3-gcc-12.2.0
proteins="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_4_Annotation/PG2_4_5_Validation/All_for_Orthofinder/LR_SR.PG2_4_4_10.2.results.longest.bed.trimmed.aa.fasta";

$conda_dir/bin/python $conda_dir/bin/busco -i $proteins -l $database -o PG2_4_4_2.1_BUSCO_proteins -m protein --cpu ${SLURM_NTASKS};

