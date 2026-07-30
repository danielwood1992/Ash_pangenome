##JOB_NUM##

#PG2_20_2
#Names of the particular assemblies, and their corresponding RNA-seq data

names="/data/home/mpx545/scripts/PG2_RealData/PG2_5_ONTQC/filtered_reads_PG2_5_2.txt_nomandshurica.names.PG2_20_fastas.SpecificRNA";

ARRAY_NUM=$(cat $names | wc -l);
ARRAY_NUM="$ARRAY_NUM $names";
echo $ARRAY_NUM;

##ARRAY_BIT##

#!/bin.bash
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=1:0:0
#$ -l h_vmem=8G
#$ -t ?
#$ -tc 100
#$ -e /data/scratch/mpx545/PG0_ShortReadStuff/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG0_ShortReadStuff/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

#module load repeatmasker/4.0.7
#TEST
#file_list=$names;
#SGE_TASK_ID=1;

#SGE_TASK
file_list=$1;
hap=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1);
hap_dir=$hap.starindex; #star index dir
ls $hap.dir #output dir...

R1=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f2);
R2=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f3);

module load miniforge;
mamba activate /data/home/mpx545/conda_environments/star;
module load samtools;

echo "STAR --readFilesCommand zcat --outSAMstrandField intronMotif --genomeDir $hap1_dir --readFilesIn $R1 $R2 --runThreadN ${NSLOTS} --outFileNamePrefix $dir/$name.star --outSAMtype BAM SortedByCoordinate;";

STAR --readFilesCommand zcat --outSAMstrandField intronMotif --genomeDir $hap1_dir --readFilesIn $R1 $R2 --runThreadN ${NSLOTS} --outFileNamePrefix $dir/$name.star --outSAMtype BAM SortedByCoordinate;

