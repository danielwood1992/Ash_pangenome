##JOB_NUM##

file="/data/home/mpx545/scripts/PG2_RealData/SraRunTable_Sollars.txt";
grep "RNA" $file | cut -f1 -d, > $file.RNA.acc;
names=$file.RNA.acc;
#names="/data/home/mpx545/scripts/PG2_RealData/PG2_4_Annotation/RNA_read_pair_list.txt_temp";

#The original set of RNA
#names="/data/home/mpx545/scripts/PG2_RealData/PG2_4_Annotation/RNA_read_pair_list.txt";

#Extra ones for NComm revisions
names="/data/home/mpx545/scripts/PG2_RealData/PG2_GitHub/2_Annotation/2_2_ShortReadMapping/NewRNA_BATG1.0Annotation.txt";


ARRAY_NUM=$(cat $names | wc -l);
ARRAY_NUM="$ARRAY_NUM $names";
echo $ARRAY_NUM;

##ARRAY_BIT##

#!/bin.bash
#$ -cwd
#$ -pe smp 8
#$ -l h_rt=1:0:0
#$ -l h_vmem=7G
#$ -t ?
#$ -tc 100
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

#TEST
#file_list=$names;
#SGE_TASK_ID=1;
#NSLOTS=2;

file_list=$1;
SRA=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1);
name=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f2);
R1=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f3);
R2=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f4);

#These get replaced by 7_2_2_2 for the appropriate files for each samples transformed fassta
dir="REPLACE_STRING_1";
hap1_dir="REPLACE_STRING_2";

#try temp:
#dir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_20_pangenome_annotation/S48_PG52_fastq.PG2_20_2.vcf.PG2_20_2.temp1.txt.PG2_20_2.kept.vcf_lines.bed.mod.fasta.dir";
#hap1_dir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_20_pangenome_annotation/S48_PG52_fastq.PG2_20_2.vcf.PG2_20_2.temp1.txt.PG2_20_2.kept.vcf_lines.bed.mod.fasta.starindex";

module load miniforge;
mamba activate /data/home/mpx545/conda_environments/star;
module load samtools;

echo "STAR --readFilesCommand zcat --outSAMstrandField intronMotif --genomeDir $hap1_dir --readFilesIn $R1 $R2 --runThreadN ${NSLOTS} --outFileNamePrefix $dir/$name.star --outSAMtype BAM SortedByCoordinate;";

STAR --readFilesCommand zcat --outSAMstrandField intronMotif --genomeDir $hap1_dir --readFilesIn $R1 $R2 --runThreadN ${NSLOTS} --outFileNamePrefix $dir/$name.star --outSAMtype BAM SortedByCoordinate;
