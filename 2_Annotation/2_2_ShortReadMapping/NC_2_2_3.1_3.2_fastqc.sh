##JOB_NUM##
#KPG0_2

reusable_pipeline="/data/home/mpx545/scripts/reusable_slurm_pipeline/";
names="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_4_Annotation/CGR_RNA/trimmed_list.txt";

ARRAY_NUM=$(cat $names | wc -l);
ARRAY_NUM="$ARRAY_NUM $names";
echo $ARRAY_NUM;

##ARRAY_BIT##

#!/bin.bash
#$ -cwd
#$ -pe smp 6
#$ -l h_rt=1:0:0
#$ -l h_vmem=5G
#$ -t ?
#$ -tc 100
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

#Set progress tracking
dat=$(date +%Y_%m_%d);

#Ok so this needs a nice name in position 0 (done) and the new nicename in position 3 in this new file (ok that's fine...);
#Defualt sort? 

#TEST
#file_list=$names;
#SGE_TASK_ID=1;

file_list=$1;
sample_name=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1);

name=$(echo $sample_name | rev | cut -f1 -d\/ | rev | cut -f1,2 -d\.)

outdir="/data/scratch/mpx545/PG2_AshPanGenome/CGR_RNA";
mkdir $outdir;

module load miniforge;
mamba activate /data/home/mpx545/conda_environments/nanoplot
export CONDA_ENVS_PATH=/data/home/mpx545/conda_environments/nanoplot/envs
export CONDA_PKGS_PATH=/data/home/mpx545/conda_environments/nanoplot/pkgs

rm -r $outdir/$name.fastqc;
mkdir $outdir/$name.fastqc;
fastqc $sample_name -o $outdir/$name.fastqc -t ${NSLOTS};

