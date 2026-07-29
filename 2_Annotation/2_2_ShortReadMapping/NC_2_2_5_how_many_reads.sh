##JOB_NUM##

names="/data/SBCS-BuggsLab-Ash/Pangenome_Data/RNAseq_Data/trimmed_list.R1.txt";

ARRAY_NUM=$(cat $names | wc -l);
ARRAY_NUM="$ARRAY_NUM $names";
echo $ARRAY_NUM;

summary="/data/home/mpx545/scripts/PG2_RealData/PG2_GitHub/2_Annotation/2_2_ShortReadMapping/read_numbers.txt";
truncate -s 0 $summary;

##ARRAY_BIT##
#!/bin/bash
#SBATCH -n 1
#SBATCH -t 1:0:0
#SBATCH --mem-per-cpu=4G
#SBATCH --array=?
#SBATCH -e /gpfs/scratch/mpx545/PG2_AshPanGenome/joblog/%x.%A.%a.err.txt
#SBATCH -o /gpfs/scratch/mpx545/PG2_AshPanGenome/joblog/%x.%A.%a.out.txt

#SGE_TASK_ID=1;
#file_list=$names;

file_list=$1;
name=$(sed -n "${SLURM_ARRAY_TASK_ID}p" $file_list | cut -f1);
summary="/data/home/mpx545/scripts/PG2_RealData/PG2_GitHub/2_Annotation/2_2_ShortReadMapping/read_numbers.txt";

echo $name;

lines=$(zcat $name | wc -l)
reads=$((lines / 4))
echo "$name\t$reads" >> $summary;


