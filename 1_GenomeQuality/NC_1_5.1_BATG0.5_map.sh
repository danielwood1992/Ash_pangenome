#!/bin.bash
#$ -cwd
#$ -pe smp 6
#$ -l h_rt=240:0:0
#$ -l h_vmem=7G
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

#Load modules
module load bwa/0.7.17-gcc-12.2.0;
module load samtools/1.19.2-python-3.11.7-gcc-12.2.0;

genome="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta.oneline.fasta.nocontam.fa";

outdir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_29_BATG1.0ID";
#sample_name="BATG0.5_DNA";

#R1="/data/SBCS-BuggsLab-Ash/DanielWood/SollarsData/F_exc_200bp_ATCACG_L004_R1_001.fastq.gz";
#R2="/data/SBCS-BuggsLab-Ash/DanielWood/SollarsData/F_exc_200bp_ATCACG_L004_R2_001.fastq.gz";

cd $outdir;

ls $R1;
ls $R2;

bwa mem -t ${NSLOTS} $genome $R1 $R2 | samtools fixmate -m - - | samtools sort - | samtools markdup -r - - | samtools view -bSq 20 -o $outdir/$sample_name.bwa.rmdpq20.bam && samtools stats $outdir/$sample_name.bwa.rmdpq20.bam > $outdir/$sample_name.bwa.rmpdpq20.bam.stats && samtools index $outdir/$sample_name.bwa.rmdpq20.bam;


