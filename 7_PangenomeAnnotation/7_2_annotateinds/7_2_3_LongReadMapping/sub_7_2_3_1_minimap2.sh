##JOB_NUM##

#KPG0_2

reusable_pipeline="/data/home/mpx545/scripts/reusable_slurm_pipeline/";
#Names of the individual trimmed long-read RNA-seq fq files
names="/data/home/mpx545/scripts/PG2_RealData/PG2_4_Annotation/PG2_4_3_LongReadMapping/filtered_fqs.txt";

ARRAY_NUM=$(cat $names | wc -l);
ARRAY_NUM="$ARRAY_NUM $names";
echo $ARRAY_NUM;

##ARRAY_BIT##

#!/bin.bash
#$ -cwd
#$ -pe smp 5
#$ -l h_rt=240:0:0
#$ -l h_vmem=7G
#$ -t ?
#$ -tc 100
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

#Load modules
module load samtools/1.9;
module load minimap2/2.5;

#TEST
#file_list=$names;
#SGE_TASK_ID=1;

#REAL
file_list=$1;

#genome="/data/SBCS-BuggsLab/DanielWood/PG2_PanGenome/raw_Genome_ROY3706_Fexcelsior_assemblies/purged.fa";
#hap2

#These are replaced by 7_2_3_1, for each of the individual fasta files
genome="REPLACE_STRING_1";
outdir="REPLACE_STRING_2";
cd $outdir;

#hap="hap2";

sample_name=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1);

name=$(echo $sample_name | rev | cut -f1 -d\/ | rev | cut -f1 -d\.)
echo $name;

minimap2 -ax splice -t 4 $genome $sample_name | samtools sort -O BAM -o $outdir/$name.rna_seq.bam;


