##JOB_NUM##
#KPG0_2

reusable_pipeline="/data/home/mpx545/scripts/reusable_slurm_pipeline/";
#Note: only a subset of the individuals had assemblies produced using nextdenovo, including the ONT data for the
#BATG-1.0 individual
names="/data/home/mpx545/scripts/PG2_RealData/PG2_9_denovoassembly/filtered_reads_denovoassemblytest480.txt";

ARRAY_NUM=$(cat $names | wc -l);
ARRAY_NUM="$ARRAY_NUM $names";
echo $ARRAY_NUM;

##ARRAY_BIT##

#!/bin.bash
#$ -cwd
#$ -pe smp 20
#$ -l h_rt=240:0:0
#$ -l h_vmem=20G
#$ -l highmem
#$ -t ?
#$ -tc 10
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

#REAL
file_list=$1;

outdir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_9_DeNovoAssembly/PG2_9_4_Nextdenovo";

mkdir -p $outdir;

threads="12";
genome_size="0.85g";
#ou need to give it a series of subsets of thread number, for some reason
threads_smaller=$(echo "0.5*($threads)/1" | bc);
threads_smaller_still=$(echo "0.25*($threads)/1" | bc);

module load anaconda3;
#This is just the conda environment where I installed nextdenovo
conda activate /data/home/mpx545/conda_environments/nanoplot
export CONDA_ENVS_PATH=/data/home/mpx545/conda_environments/nanoplot/envs
export CONDA_PKGS_PATH=/data/home/mpx545/conda_environments/nanoplot/pkgs

sample_name=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1);

name=$(echo $sample_name | rev | cut -f1 -d\/ | rev | cut -f1 -d\.)
echo $name;

#Set up the config file
mkdir -p $outdir/$name.nextdenovo;
outdir=$outdir/$name.nextdenovo;
cd $outdir;

echo $sample_name >> $outdir/$name.nextdenovo.fofn;
fofn=$outdir/$name.nextdenovo.fofn;

#Get base config
config="/data/home/mpx545/NextDenovo/doc/run.cfg";
cp $config $outdir/$name.config;

#Update information
sed -i "s|job_prefix = nextDenovo|job_prefix = $name.nextDenovo|g" $outdir/$name.config;
sed -i "s/parallel_jobs = 20/parallel_jobs = $threads/g" $outdir/$name.config;
sed -i "s/read_type = clr/read_type = ont/g" $outdir/$name.config;
sed -i "s|workdir = 01_rundir|workdir = $outdir|g" $outdir/$name.config;
sed -i "s|genome_size = 1g|genome_size = $genome_size|g" $outdir/$name.config;
sed -i "s|input_fofn = input.fofn|input_fofn = $fofn|g" $outdir/$name.config;
sed -i "s|\-t 15|\-t $threads_smaller|g" $outdir/$name.config;
sed -i "s|\-t 8|\-t $threads_smaller_still|g" $outdir/$name.config;

#Run
~/NextDenovo/nextDenovo $outdir/$name.config;
