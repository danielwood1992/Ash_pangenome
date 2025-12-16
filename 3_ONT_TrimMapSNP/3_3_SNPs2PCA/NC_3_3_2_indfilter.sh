##JOB_NUM##

#KPG0_2

reusable_pipeline="/data/home/mpx545/scripts/reusable_slurm_pipeline/";
names="/data/home/mpx545/scripts/PG2_RealData/PG2_5_ONTQC/filtered_reads_PG2_5_2.txt";
head -n 1 $names > $names.tstPG2_22;
names="$names.tstPG2_22";

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

#Load modules
#module load bwa/0.7.17;
module load samtools/1.9;
module load bcftools/1.19-gcc-12.2.0

#Set progress tracking

#REAL
file_list=$1;

genome="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta";

sample_name=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1);
dir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_6_Mapping";
suffix="hap1.rmdpq20.bam";

name=$(echo $sample_name | rev | cut -f1 -d\/ | rev | cut -f1 -d\.)
echo $name;
bam_name=$dir/$name.$suffix;
outdir=$bam_name.sorted.bam.clair
vcf="$outdir/merge_output.gvcf.gz";

ls $vcf;

bcftools view $vcf | bcftools norm -m +any --fasta-ref $genome | bcftools +fill-tags -- -t all | bcftools plugin setGT - -- -t q -n . -i "FMT/DP < 8 | FMT/DP > 100" | bcftools view - -Ob -o $bam_name.tomerge.bcf;
bcftools index $bam_name.tomerge.bcf;


