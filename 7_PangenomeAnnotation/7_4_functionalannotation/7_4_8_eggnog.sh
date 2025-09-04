#!/bin.bash
#$ -cwd
#$ -pe smp 4
#$ -l h_rt=240:0:0
#$ -l h_vmem=7G
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt


module load miniconda;
mamba activate /data/SBCS-BuggsLab-Ash/DanielWood/conda_environments/eggnog; 
export EGGNOG_DATA_DIR="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_26_FunctionalAnnotation/eggnogg_db";

#download_eggnog_data.py
fasta="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_26_FunctionalAnnotation/protein_seqs_PG2_20_complete.fasta";

outdir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_26_FunctionalAnnotation/PG2_26_4_eggnog";

rm -r $outdir;
mkdir $outdir;
cd $outdir;
emapper.py --cpu ${NSLOTS} -i $fasta -o $outdir --override;


