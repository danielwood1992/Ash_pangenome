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
#$ -pe smp 1
#$ -l h_rt=1:0:0
#$ -l h_vmem=8G
#$ -t ?
#$ -tc 100
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

module load miniconda;
conda activate /data/home/mpx545/conda_environments/cuteSV
export CONDA_ENVS_PATH=/data/home/mpx545/conda_environments/cuteSV/envs
export CONDA_PKGS_PATH=/data/home/mpx545/conda_environments/cuteSV/pkgs

file_list=$1;

bam_dir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_6_Mapping";
outdir="/data/scratch/mpx545/PG2_AshPanGenome";

bam_name=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1);
name=$(echo $bam_name | rev | cut -f1 -d\/ | rev | cut -f1 -d\.)
bam_name=$name.hap1.rmdpq20.bam;

ls $bam_dir/$bam_name;

echo $bam;
echo $name;


genome="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta";

#Run cuteSV
cuteSV --threads 3 -s 5 --max_cluster_bias_INS 100 --diff_ratio_merging_INS 0.3 --max_cluster_bias_DEL 100 --diff_ratio_merging_DEL 0.3 --genotype $bam_dir/$bam_name $genome $outdir/$bam_name.cuteSV.vcf $outdir/$name.cuteSV;

#Remove 0/0 calls and breakends
grep -v "0\/0" $outdir/$bam_name.cuteSV.vcf > $outdir/$bam_name.cuteSV.filt.vcf;
grep -v "SVTYPE=BND" $outdir/$bam_name.cuteSV.filt.vcf > $outdir/$bam_name.cuteSV.filt2.vcf;
