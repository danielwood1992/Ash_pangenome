##JOB_NUM##
#KPG0_2

#For how this submission script works, see qarray.sh README.txt

reusable_pipeline="/data/home/mpx545/scripts/reusable_slurm_pipeline/";
#names="/data/home/mpx545/scripts/PG0_ShortReadStuff/Owen_Data.txt";
names="/data/home/mpx545/scripts/PG2_RealData/PG2_15_vgmap/PoolFileList.txt";

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
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt

file_list=$1;
name=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1);
R1=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f2);
R2=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f3);

#Set progress tracking
dat=$(date +%Y_%m_%d);


reference="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta";

outdir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_15_giraffe";

vcf=$outdir/$name.PATCH.gam.snarls.PG2_15_2.vcf;

#This extracts the ref/alt data and outputs it to a file $vcf.adstats
sub="/data/home/mpx545/scripts/PG2_RealData/PG2_GitHub/9_PoolSeq_Pangenome/9_2_Calls/sub_9_2_2_getcounts.pl";
perl $sub $vcf;

