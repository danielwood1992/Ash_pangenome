#!/bin.bash
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=1:0:0
#$ -l h_vmem=5G
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

fasta="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_12_merge/complete_merged_PG2_12_2.all_types.all_types.tags.vcf.uniqnames.reffixed2.1.seqs";
#cp $fasta_dir/$fasta $outdir;

module load miniconda;
conda activate /data/home/mpx545/conda_environments/blobtools2;
#/data/home/mpx545/scripts/PG2_RealData/PG2_2_GenomeQuality/cantata_assemblies.txt/data/home/mpx545/scripts/PG2_RealData/PG2_2_GenomeQuality/cantata_assemblies.txtblobtools--version;
blobtools create --fasta $fasta $fasta.blobdir;




