#!/bin/bash
#SBATCH -n 1
#SBATCH -t 1:0:0
#SBATCH --mem-per-cpu=6G
#SBATCH -e /gpfs/scratch/mpx545/PG2_AshPanGenome/joblog/%x.%A.%a.err.txt
#SBATCH -o /gpfs/scratch/mpx545/PG2_AshPanGenome/joblog/%x.%A.%a.out.txt

module load bcftools/1.19-gcc-12.2.0
list="/gpfs/scratch/mpx545/PG2_AshPanGenome/glnexus.results/nat_sort.txt";
dir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_6_Mapping";

#bcftools concat -f $list -Ob -o $dir/NC_clair3_combined.bcf
bcftools view -s ^DW-S26_PGA5 -Ob -o $dir/NC_clair3_combined.noref.bcf $dir/NC_clair3_combined.bcf


