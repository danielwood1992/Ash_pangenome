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
#$ -pe smp 24
#$ -l h_rt=1:0:0
#$ -l h_vmem=12G
#$ -t ?
#$ -tc 100
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

file_list=$1;

outdir="/data/scratch/mpx545/PG2_AshPanGenome";

sample_name=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1);

name=$(echo $sample_name | rev | cut -f1 -d\/ | rev | cut -f1 -d\.)
echo $name;

module load anaconda3;
conda activate /data/home/mpx545/conda_environments/shasta
export CONDA_ENVS_PATH=/data/home/mpx545/conda_environments/shasta/envs
export CONDA_PKGS_PATH=/data/home/mpx545/conda_environments/shasta/pkgs

#Need unzupped reads for running shasta
zcat $sample_name > $outdir/$name.unzipped.fq;
rm -r $outdir/$name.shasta;
shasta --input $outdir/$name.unzipped.fq --config Nanopore-May2022 --assemblyDirectory $outdir/$name.shasta --threads 24;
#rm $outdir/$name.unzipped.fq;


