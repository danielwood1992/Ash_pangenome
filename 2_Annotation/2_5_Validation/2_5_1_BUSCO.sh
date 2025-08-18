#!/bin.bash
#$ -cwd
#$ -pe smp 4
#$ -l h_rt=1:0:0
#$ -l h_vmem=7G
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

module load miniconda;
mamba activate /data/home/mpx545/conda_environments/busco
export CONDA_ENVS_PATH=/data/home/mpx545/conda_environments/busco/envs
export CONDA_PKGS_PATH=/data/home/mpx545/conda_environments/busco/pkgs
#busco --help;


database="/data/home/mpx545/eudicots_odb10";

outdir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_4_Annotation/PG2_4_5_Validation/PG2_4_4_2.1_BUSCO_proteins_update";
rm -r $outdir;
mkdir $outdir;
cd $outdir;

module load hmmer/3.1b2;
proteins="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_4_Annotation/PG2_4_5_Validation/All_for_Orthofinder/LR_SR.PG2_4_4_10.2.results.longest.bed.aa.fasta";

busco -i $proteins -l $database -o PG2_4_4_2.1_BUSCO_proteins -m protein --cpu ${NSLOTS};







