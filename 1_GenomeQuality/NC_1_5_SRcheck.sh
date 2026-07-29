##JOB_NUM##
#KPG0_2

reusable_pipeline="/data/home/mpx545/scripts/reusable_slurm_pipeline/";
#names="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/CGR_DNASeq/Raw/all_DW/list.txt";

names="/data/home/mpx545/scripts/PG2_RealData/PG2_15_vgmap/test_set_individuals.txt.5";
ARRAY_NUM=$(cat $names | wc -l);
ARRAY_NUM="$ARRAY_NUM $names";
echo $ARRAY_NUM;

##ARRAY_BIT##
#!/bin/bash
#SBATCH -n 6
#SBATCH -t 240:0:0
#SBATCH --mem-per-cpu=5G
#SBATCH --array=?
#SBATCH -e /gpfs/scratch/mpx545/PG2_AshPanGenome/joblog/%x.%A.%a.err.txt
#SBATCH -o /gpfs/scratch/mpx545/PG2_AshPanGenome/joblog/%x.%A.%a.out.txt

#Load modules
module load bwa/0.7.17-gcc-12.2.0;
module load samtools/1.19.2-python-3.11.7-gcc-12.2.0;

file_list=$1;
sample_name=$(sed -n "${SLURM_ARRAY_TASK_ID}p" $file_list | cut -f1);
R1=$(sed -n "${SLURM_ARRAY_TASK_ID}p" $file_list | cut -f2);
R2=$(sed -n "${SLURM_ARRAY_TASK_ID}p" $file_list | cut -f3);


genome="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta.oneline.fasta.nocontam.fa";

outdir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_29_BATG1.0ID";

cd $outdir;

ls $R1;
ls $R2;

bwa mem -t ${SLURM_NTASKS} $genome $R1 $R2 | samtools fixmate -m - - | samtools sort - | samtools markdup -r - - | samtools view -bSq 20 -o $outdir/$sample_name.bwa.rmdpq20.bam && samtools stats $outdir/$sample_name.bwa.rmdpq20.bam > $outdir/$sample_name.bwa.rmpdpq20.bam.stats && samtools index $outdir/$sample_name.bwa.rmdpq20.bam;

