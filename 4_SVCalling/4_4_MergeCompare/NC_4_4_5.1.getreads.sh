###JOB_NUM##
#KPG0_2

reusable_pipeline="/data/home/mpx545/scripts/reusable_slurm_pipeline/";

list="/data/home/mpx545/scripts/PG2_RealData/PG2_GitHub/4_SVCalling/4_4_MergeCompare/validation_list.txt";

xargs cat < $list > $list.SVs;

sub="/data/home/mpx545/scripts/PG2_RealData/PG2_GitHub/4_SVCalling/4_4_MergeCompare/sub_NC_4_4_5.1_getreads.pl";
perl $sub $list.SVs;

names=$list.SVs.out;

ARRAY_NUM=$(cat $names | wc -l);
ARRAY_NUM="$ARRAY_NUM $names";
echo $ARRAY_NUM;

##ARRAY_BIT##

#!/bin.bash
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=1:0:0
#$ -l h_vmem=7G
#$ -t ?
#$ -tc 100
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

#file_list=$1;

file_list=$names;
SGE_TASK_ID=1;

SV=$(sed -n "${SGE_TASK_ID}p" $file_list);
echo $SV;

module load bcftools/1.19-gcc-12.2.0;





