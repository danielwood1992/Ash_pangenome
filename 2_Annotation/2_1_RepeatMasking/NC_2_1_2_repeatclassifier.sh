#!/bin.bash
#$ -cwd
#$ -pe smp 2
#$ -l h_rt=240:0:0
#$ -l h_vmem=5G

module load miniconda;
mamba activate /data/home/mpx545/conda_environments/repeatmodeler
export CONDA_ENVS_PATH=/data/home/mpx545/conda_environments/repeatmodeler/envs
export CONDA_PKGS_PATH=/data/home/mpx545/conda_environments/repeatmodeler/pkgs

hap1="/data/SBCS-BuggsLab/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta";
lib="/data/home/mpx545/scripts/PG2_RealData/PG2_4_Annotation/RM_200791.MonFeb61712262023/consensi.fa";

repeatclassifier="/data/home/mpx545/conda_environments/repeatmodeler/bin/RepeatClassifier";


consensi="/data/home/mpx545/scripts/PG2_RealData/PG2_4_Annotation/RM_200791.MonFeb61712262023/consensi.fa
";
stockholm="/data/home/mpx545/scripts/PG2_RealData/PG2_4_Annotation/RM_200791.MonFeb61712262023/families.stk";

#export PATH="/data/home/mpx545/conda_environments/repeatmodeler/lib/perl5:$PATH"
$repeatclassifier -consensi $consensi -stockholm $stockholm;

