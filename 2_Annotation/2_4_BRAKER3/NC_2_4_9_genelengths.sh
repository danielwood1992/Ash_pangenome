#!/bin/bash
#SBATCH -n 1
#SBATCH -t 1:0:0
#SBATCH --mem-per-cpu=5G
#SBATCH -e /gpfs/scratch/mpx545/PG2_AshPanGenome/joblog/%x.%A.%a.err.txt
#SBATCH -o /gpfs/scratch/mpx545/PG2_AshPanGenome/joblog/%x.%A.%a.out.txt

#module load bedtools2/;

genes="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_4_Annotation/PG2_4_9.4_orthofinder/OrthoFinder/Results_Feb23_1/Orthogroups/PG2_4_4_10.2/LR_SR.PG2_4_4_10.2.results.longest.bed.trimmed.gene";
long_only="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_4_Annotation/PG2_4_9.4_orthofinder/OrthoFinder/Results_Feb23_1/Orthogroups/PG2_4_4_10.2/LR_all_SR_none_names.Mar26.csv";
short_only="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_4_Annotation/PG2_4_9.4_orthofinder/OrthoFinder/Results_Feb23_1/Orthogroups/PG2_4_4_10.2/SR_all_LR_none_names.Mar26.csv";
tail -n+2 $short_only | cut -f2 -d, | rev | cut -f1 -d\/ | rev | sed 's/"//g' | awk 'NR==FNR {p[$1]; next} $NF in p' - $genes | awk '{print $6 - $5}' | sed 's/\-//g' > $short_only.lengths;
tail -n+2 $long_only | cut -f2 -d, | rev | cut -f1 -d\/ | rev | sed 's/"//g' | awk 'NR==FNR {p[$1]; next} $NF in p' - $genes | awk '{print $6 - $5}' | sed 's/\-//g' > $long_only.lengths;    
