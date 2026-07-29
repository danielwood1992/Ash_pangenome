##JOB_NUM##

reusable_pipeline="/data/home/mpx545/scripts/reusable_slurm_pipeline/";
names="/data/home/mpx545/scripts/PG2_RealData/PG2_5_ONTQC/filtered_reads_PG2_5_2.txt";

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

module load miniconda;
conda activate /data/home/mpx545/conda_environments/sniffles;

#REAL
file_list=$1;

outdir="/data/scratch/mpx545/PG2_AshPanGenome";

bam_name=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1);
bam_dir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_6_Mapping";

name=$(echo $bam_name | rev | cut -f1 -d\/ | rev | cut -f1 -d\.)
bam_name=$name.hap1.rmdpq20.bam;
ls $bam_dir/$bam_name;

#echo $bam;
echo $name;

genome="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta";

#Calls SVs using Sniffles, with minimum support of 5 reads required
sniffles --input $bam_dir/$bam_name --snf $outdir/$bam_name.hap1.snf --vcf $outdir/$bam_name.hap1.sniffles.vcf --reference $genome -t 4 --minsupport 5 --allow-overwrite;

#Remove calls that are homozygous reference, or breakends only
grep -v "0\/0" $outdir/$bam_name.hap1.sniffles.vcf > $outdir/$bam_name.hap1.sniffles.filt.vcf;
grep -v "SVTYPE=BND" $outdir/$bam_name.hap1.sniffles.filt.vcf > $outdir/$bam_name.hap1.sniffles.filt2.vcf;

