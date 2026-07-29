##JOB_NUM##

#Script that takes a list of sra info from the Sollars paper,
#extracts the samples from the genome plant (excluding RNA seq),
#and then batch downloads these using fastq-dump to the specified location.

dir="/data/SBCS-BuggsLab-Ash/DanielWood/lesion_RNA";
mkdir $dir;

names="/data/home/mpx545/scripts/PG2_RealData/PG2_GitHub/2_Annotation/2_2_ShortReadMapping/lesion_sra.txt";

ARRAY_NUM=$(cat $names | wc -l);
ARRAY_NUM="$ARRAY_NUM $names";
echo $ARRAY_NUM;

##ARRAY_BIT##

#!/bin.bash
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=1:0:0
#$ -l h_vmem=5G
#$ -t ?
#$ -tc 100
#$ -e /data/scratch/mpx545/PG0_ShortReadStuff/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG0_ShortReadStuff/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

#TEST
#file_list=$names;
#SGE_TASK_ID=1;

file_list=$1;
file=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1);
#module load sratools;
module load miniforge;
mamba activate /data/SBCS-BuggsLab-Ash/DanielWood/conda_environments/sratools;

dir="/data/SBCS-BuggsLab-Ash/DanielWood/lesion_RNA";
cd $dir;

#fasterq-dump --split-files $file -O $dir && echo $file >> $dir/Progress.txt;
gzip $dir/$file*fastq*
