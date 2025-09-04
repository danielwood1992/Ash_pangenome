#!/bin.bash
#$ -cwd
#$ -pe smp 8
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
outdir="/data/scratch/mpx545/PG2_AshPanGenome/PG2_2_5_BUSCO";
mkdir $outdir;
cd $outdir;

pangenome="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_26_FunctionalAnnotation/protein_seqs_PG2_20_complete.fasta";
included_list="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_26_FunctionalAnnotation/protein_seqs_PG2_20_complete.fasta.list.I";

sub="/data/home/mpx545/scripts/PG2_RealData/PG2_GitHub/fasta_fromlist.pl";
perl $sub $included_list $pangenome I
#output is $pangenome.I.fa

busco -f -i $pangenome.I.fa -l $database -o pangenome.I -m proteins --cpu ${NSLOTS};



