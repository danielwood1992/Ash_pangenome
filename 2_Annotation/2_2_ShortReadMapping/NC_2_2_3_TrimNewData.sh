##JOB_NUM##
#KPG0_2

reusable_pipeline="/data/home/mpx545/scripts/reusable_slurm_pipeline/";
names="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/CGR_RNASeq/Raw/all_samples/sample_info.txt";

#head -n 2 $names > $names.2;
#names=$names.2;

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

#TEST
#file_list=$names;
#SGE_TASK_ID=1;

file_list=$1;

outdir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_4_Annotation/CGR_RNA";

sample_name=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1);
R1=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f2);
R2=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f3);

adapters="/data/home/mpx545/scripts/PG2_RealData/PG2_GitHub/2_Annotation/2_2_ShortReadMapping/CGR_RNA_adapters.fa";

module load openjdk;
java -jar /data/home/mpx545/Trimmomatic-0.39/trimmomatic-0.39.jar PE -phred33 $R1 $R2 $outdir/$sample_name.R1.paired.trimmo.fq.gz $outdir/$sample_name.R1.unpaired.trimmo.fq.gz $outdir/$sample_name.R2.paired.trimmo.fq.gz $outdir/$sample_name.R2.unpaired.trimmo.fq.gz LEADING:7 TRAILING:7 ILLUMINACLIP:$adapters:2:30:7 MINLEN:70;
