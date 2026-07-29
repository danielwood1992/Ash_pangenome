##JOB_NUM##

names="/data/home/mpx545/scripts/PG2_RealData/PG2_GitHub/2_Annotation/2_2_ShortReadMapping/NewRNA_BATG1.0Annotation.txt";
ARRAY_NUM=$(cat $names | wc -l);
ARRAY_NUM="$ARRAY_NUM $names";
echo $ARRAY_NUM;

##ARRAY_BIT##

#!/bin.bash
#$ -cwd
#$ -pe smp 10
#$ -l h_rt=1:0:0
#$ -l h_vmem=7G
#$ -t ?
#$ -tc 100
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt


#SGE_TASK_ID=1;
#file_list=$names;

file_list=$1;
name=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f2);
R1=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f3);
R2=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f4);

echo $name;
ls $R1;
ls $R2;


reusable_pipeline="/data/home/mpx545/scripts/reusable_slurm_pipeline/";
genome_dir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies";
hap1="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta";

dir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_4_Annotation";

module load miniforge;
mamba activate /data/home/mpx545/conda_environments/star;
#module load samtools;

STAR --readFilesCommand zcat --outSAMstrandField intronMotif --genomeDir $hap1.starindex --readFilesIn $R1 $R2 --runThreadN ${NSLOTS} --outFileNamePrefix $dir/$name.star2 --outSAMtype BAM SortedByCoordinate;
