##JOB_NUM##
#PG2_5_1: 
#Seems like each fastq line from ONT only has 1600 lines for some reason. So I am concatenating these all together for the time being.
#Find out why some of them have differnt starting strings, though.

reusable_pipeline="/data/home/mpx545/scripts/reusable_slurm_pipeline/";
names="/data/home/mpx545/scripts/PG2_RealData/PG2_5_ONTQC/batch2_list.txt";

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
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

reusable_pipeline="/data/home/mpx545/scripts/reusable_slurm_pipeline/";
new_dir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/ont_cdna_simplex_data";

script_dir="/data/home/mpx545/scripts/PG2_RealData/PG2_5_ONTQC";

file_list=$1;
file=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1);
name=$(echo $file | rev | cut -f1 -d\/ | rev);
echo $name;

cat $file/*/*fastq_pass*/*gz > $new_dir/$name.fq.gz && echo "$new_dir/$name.fq.gz" >> $script_dir/PG2_5_1_fqlist.txt;

