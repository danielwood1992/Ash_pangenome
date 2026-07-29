##JOB_NUM##
#KPG0_2

reusable_pipeline="/data/home/mpx545/scripts/reusable_slurm_pipeline/";
names="/data/home/mpx545/scripts/PG2_RealData/PG2_5_ONTQC/filtered_reads_PG2_5_2.txt";
ARRAY_NUM=$(cat $names | wc -l);
ARRAY_NUM="$ARRAY_NUM $names";
echo $ARRAY_NUM;

##ARRAY_BIT##

#!/bin.bash
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=240:0:0
#$ -l h_vmem=5G
#$ -t ?
#$ -tc 100
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

#Load modules
module load bwa/0.7.17;
module load samtools/1.9;

#Set progress tracking
dat=$(date +%Y_%m_%d);

outdir="/data/scratch/mpx545/PG2_AshPanGenome";

file_list=$1;
sample_name=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1);

name=$(echo $sample_name | rev | cut -f1 -d\/ | rev | cut -f1 -d\.)
echo $name;
module load anaconda3;
conda activate /data/home/mpx545/conda_environments/nanoplot
export CONDA_ENVS_PATH=/data/home/mpx545/conda_environments/nanoplot/envs
export CONDA_PKGS_PATH=/data/home/mpx545/conda_environments/nanoplot/pkgs

NanoPlot --fastq $sample_name --raw -o $outdir/$name.nanoplot 
