##JOB_NUM##
#KPG0_2

reusable_pipeline="/data/home/mpx545/scripts/reusable_slurm_pipeline/";
names="/data/home/mpx545/scripts/PG2_RealData/PG2_10_alignfastas/assembly_list.txt";
ARRAY_NUM=$(cat $names | wc -l);
ARRAY_NUM="$ARRAY_NUM $names";
echo $ARRAY_NUM;

##ARRAY_BIT##

#!/bin.bash
#$ -cwd
#$ -pe smp 4
#$ -l h_rt=1:0:0
#$ -l h_vmem=7G
#$ -t ?
#$ -tc 100
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

#TEST
#file_list=$names;
#SGE_TASK_ID=1;

#REAL

file_list=$1;

#genome="/data/SBCS-BuggsLab/DanielWood/PG2_PanGenome/raw_Genome_ROY3706_Fexcelsior_assemblies/purged.fa";
outdir="/data/scratch/mpx545/PG2_AshPanGenome";
genome="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta";

sample_name=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1);
base_name=$(echo $sample_name | rev | cut -f2 -d'/' | rev)
dir_name=$(dirname $sample_name)

echo "base_name" $base_name;
echo "dir_name" $dir_name;
echo "sample_name" $sample_name;
#echo $name;
module load minimap2/2.5;
module load samtools;
ls $dir_name;
minimap2 -ax asm10 -t 4 $genome $sample_name | samtools sort -O BAM -o $dir_name/minimap2.bam;
samtools index $dir_name/minimap2.bam;
#samtools stats $outdir/$shasta_name.hap1.minimap2.bam > $outdir/$shasta_name.hap1.minimap2.bam.stats;

