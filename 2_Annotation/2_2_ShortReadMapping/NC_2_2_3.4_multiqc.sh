#!/bin.bash
#$ -cwd
#$ -pe smp 8
#$ -l h_rt=1:0:0
#$ -l h_vmem=5G
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

#Load modules
#module load python/3.8.5-gcc-12.2.0;

#Set progress tracking
dat=$(date +%Y_%m_%d);

#Ok so this needs a nice name in position 0 (done) and the new nicename in position 3 in this new file (ok that's fine...);
#Defualt sort? 

module load miniforge;
mamba activate /data/home/mpx545/conda_environments/blobtools2;

multiqc --help;

#outdir="/data/scratch/mpx545/PG2_AshPanGenome/CGR_RNA/R1_all_fastqc";

#outdir="/data/scratch/mpx545/PG2_AshPanGenome/CGR_RNA/DR_fastqc";

outdir="/data/scratch/mpx545/PG2_AshPanGenome/CGR_RNA/SR_fastqc";

multiqc $outdir --outdir $outdir/multiqc; 




