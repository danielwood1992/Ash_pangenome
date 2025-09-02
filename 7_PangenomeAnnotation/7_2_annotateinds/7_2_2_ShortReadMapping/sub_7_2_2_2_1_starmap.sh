##JOB_NUM##

file="/data/home/mpx545/scripts/PG2_RealData/SraRunTable_Sollars.txt";
grep "RNA" $file | cut -f1 -d, > $file.RNA.acc;
names=$file.RNA.acc;
#names="/data/home/mpx545/scripts/PG2_RealData/PG2_4_Annotation/RNA_read_pair_list.txt_temp";
names="/data/home/mpx545/scripts/PG2_RealData/PG2_4_Annotation/RNA_read_pair_list.txt";

ARRAY_NUM=$(cat $names | wc -l);
ARRAY_NUM="$ARRAY_NUM $names";
echo $ARRAY_NUM;

##ARRAY_BIT##

#!/bin.bash
#$ -cwd
#$ -pe smp 12
#$ -l h_rt=1:0:0
#$ -l h_vmem=7G
#$ -t ?
#$ -tc 100
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

#TEST
#file_list=$names;
#SGE_TASK_ID=1;

file_list=$1;
SRA=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1);
name=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f2);
R1=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f3);
R2=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f4);

#These get replaced by 7_2_2_2 for the appropriate files for each samples transformed fassta
dir="REPLACE_STRING_1";
hap1_dir="REPLACE_STRING_2";

module load miniconda;
mamba activate /data/home/mpx545/conda_environments/star;
module load samtools;

STAR --outSAMstrandField intronMotif --genomeDir $hap1_dir --readFilesIn $R1 $R2 --runThreadN 12 --outFileNamePrefix $dir/$name.star --outSAMtype BAM SortedByCoordinate;

