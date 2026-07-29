##JOB_NUM##

#Script that takes a list of sra info from the Sollars paper,
#extracts the samples from the genome plant (excluding RNA seq),
#and then batch downloads these using fastq-dump to the specified location.

file="/data/home/mpx545/scripts/PG2_RealData/SraRunTable_Sollars.txt";
grep "RNA" $file | cut -f1 -d, > $file.RNA.acc;
names=$file.RNA.acc;
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
#$ -e /data/scratch/mpx545/PG0_ShortReadStuff/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG0_ShortReadStuff/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

#TEST
#file_list=$names;
#SGE_TASK_ID=1;

file_list=$1;
dir="/data/SBCS-BuggsLab/DanielWood/SollarsData/RNA";
file=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1);
module load sratools;
fastq-dump --split-files --gzip $file -O $dir && echo $file >> $dir/Progress.txt;
