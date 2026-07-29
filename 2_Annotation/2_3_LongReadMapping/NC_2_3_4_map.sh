##JOB_NUM##

#KPG0_2

reusable_pipeline="/data/home/mpx545/scripts/reusable_slurm_pipeline/";
names="/data/home/mpx545/scripts/PG2_RealData/PG2_4_Annotation/PG2_4_3_LongReadMapping/filtered_fqs.txt";

#names="";

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
#module load bwa/0.7.17;
module load samtools/1.9;
module load minimap2/2.5;

#REAL
file_list=$1;

outdir="/data/scratch/mpx545/PG2_AshPanGenome";
cd $outdir;

#hap1
genome="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta";
hap="hap1";

sample_name=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1);
ls $sample_name;

name=$(echo $sample_name | rev | cut -f1 -d\/ | rev | cut -f1 -d\.)
echo $name;

minimap2 -ax splice -t 4 $genome $sample_name | samtools sort -O BAM -o $outdir/$name.rna_seq2.$hap.bam;
