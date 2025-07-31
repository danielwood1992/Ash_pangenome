##JOB_NUM##

file="/data/home/mpx545/scripts/PG2_RealData/SraRunTable_Sollars.txt";
grep "RNA" $file | cut -f1 -d, > $file.RNA.acc;
names=$file.RNA.acc;
#names="/data/home/mpx545/scripts/PG2_RealData/PG2_4_Annotation/RNA_read_pair_list.txt_temp";
names="/data/home/mpx545/scripts/PG2_RealData/PG2_4_Annotation/RNA_read_pair_list.txt";

ARRAY_NUM=$(cat $names | wc -l);
ARRAY_NUM="$ARRAY_NUM $names";
echo $ARRAY_NUM;

##ARRAY_BIT##

#!/bin.bash
#$ -cwd
#$ -pe smp 4
#$ -l h_rt=240:0:0
#$ -l h_vmem=7G
#$ -t ?
#$ -tc 100
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt


file_list=$1;
SRA=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1);
name=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f2);
R1=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f3);
R2=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f4);


reusable_pipeline="/data/home/mpx545/scripts/reusable_slurm_pipeline/";
dir="/data/scratch/mpx545/PG2_AshPanGenome";
prog="/data/scratch/mpx545/PG2_AshPanGenome/PG2_4_2.2_Progress.txt";
genome_dir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies";
hap1="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta";

module load miniconda;
mamba activate /data/home/mpx545/conda_environments/star;
module load samtools;

#for i in {1..10}; 
#for i in {10..11}; 
	do STAR --outSAMstrandField intronMotif --genomeDir $hap1.starindex --readFilesIn $R1 $R2 --runThreadN ${NSLOTS} --outFileNamePrefix $dir/$name.$i.star2 --outSAMtype BAM SortedByCoordinate;
done

