##JOB_NUM##
#KPG0_2

reusable_pipeline="/data/home/mpx545/scripts/reusable_slurm_pipeline/";
names="/data/home/mpx545/scripts/PG2_RealData/PG2_5_ONTQC/PG2_5_1_fqlist.txt";

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

#TEST
#file_list=$names;
#SGE_TASK_ID=1;

outdir="/data/scratch/mpx545/PG2_AshPanGenome";
final_outdir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/ont_simplex_data";

file_list=$1;
sample_name=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1);
outlist="/data/home/mpx545/scripts/PG2_RealData/PG2_5_ONTQC/filtered_reads_PG2_5_2.txt"
truncate -s 0 $outlist;

name=$(echo $sample_name | rev | cut -f1 -d\/ | rev | cut -f1 -d\.)
echo $name;
module load anaconda3;
conda activate /data/home/mpx545/conda_environments/nanoplot
export CONDA_ENVS_PATH=/data/home/mpx545/conda_environments/nanoplot/envs
export CONDA_PKGS_PATH=/data/home/mpx545/conda_environments/nanoplot/pkgs

module load java;
tmp_name=$outdir/$name.tmptrimmo.fq.gz;
echo $tmp_name;
java -jar /data/home/mpx545/Trimmomatic-0.39/trimmomatic-0.39.jar SE -phred33 $sample_name $tmp_name LEADING:7 TRAILING:7;  
gunzip -c $tmp_name | NanoFilt -q 7 -l 1000 | gzip > $sample_name.trimmo.q7.trimmed.gz && echo "$sample_name.trimmo.q7.trimmed.gz" >> $outlist ;
cp $sample_name.trimmo.q7.trimmed.gz $final_outdir; 
