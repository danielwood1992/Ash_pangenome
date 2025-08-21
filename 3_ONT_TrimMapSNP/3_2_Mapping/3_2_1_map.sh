##JOB_NUM##

#KPG0_2

reusable_pipeline="/data/home/mpx545/scripts/reusable_slurm_pipeline/";
names="/data/home/mpx545/scripts/PG2_RealData/PG2_5_ONTQC/filtered_reads_PG2_5_2.txt";

ARRAY_NUM=$(cat $names | wc -l);
ARRAY_NUM="$ARRAY_NUM $names";
echo $ARRAY_NUM;

##ARRAY_BIT##

#!/bin.bash
#$ -cwd
#$ -pe smp 6
#$ -l h_rt=240:0:0
#$ -l h_vmem=7G
#$ -t ?
#$ -tc 100
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

#Load modules
#module load bwa/0.7.17;
module load samtools/1.9;

#Set progress tracking
dat=$(date +%Y_%m_%d);

#REAL
file_list=$1;

#genome="/data/SBCS-BuggsLab/DanielWood/PG2_PanGenome/raw_Genome_ROY3706_Fexcelsior_assemblies/purged.fa";
outdir="/data/scratch/mpx545/PG2_AshPanGenome";

cd $outdir;
genome="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta";

sample_name=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1);

name=$(echo $sample_name | rev | cut -f1 -d\/ | rev | cut -f1 -d\.)
echo $name;
module load minimap2/2.5;

minimap2 -ax map-ont -t 4 $genome $sample_name | samtools sort -O BAM -o $outdir/$name.hap1.bam;

samtools view -b -T $genome $outdir/$name.hap1.bam | samtools sort - | samtools markdup -r - - | samtools view -bSq 20 -o $outdir/$name.hap1.rmdpq20.bam && samtools stats $outdir/$name.hap1.rmdpq20.bam > $outdir/$name.hap1.rmpdpq20.bam.stats && samtools index $outdir/$name.hap1.rmdpq20.bam;

samtools index $outdir/$name.rmdpq20.bam; 
samtools index $outdir/$name.hap1.rmdpq20.bam; 


